import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/item_groups_table.dart';
import 'tables/item_types_table.dart';
import 'tables/ornaments_table.dart';
import 'tables/status_history_table.dart';
import 'tables/silver_plus_boxes_table.dart';
import 'tables/silver_plus_allocations_table.dart';
import 'tables/old_silver_entries_table.dart';

export 'tables/ornaments_table.dart' show OrnamentStatus;
export 'tables/silver_plus_allocations_table.dart' show AllocationStatus;

part 'app_database.g.dart';

@DriftDatabase(tables: [
  ItemGroups,
  ItemTypes,
  Ornaments,
  StatusHistories,
  SilverPlusBoxes,
  SilverPlusAllocations,
  OldSilverEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String dbFilePath) : super(_openConnection(dbFilePath));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(itemGroups).insert(const ItemGroupsCompanion(name: Value('Gold')));
          await into(itemGroups).insert(const ItemGroupsCompanion(name: Value('Silver')));
        },
        onUpgrade: (m, from, to) async {
          // v1 -> v2: adds Silver+ boxes and Old Silver. Purely additive
          // — no existing table is touched.
          if (from < 2) {
            await m.createTable(silverPlusBoxes);
            await m.createTable(oldSilverEntries);
          }
          // v2 -> v3: replaces the old append-only SilverPlusSales table
          // with SilverPlusAllocations (Pending + Sold merged into one
          // table with a status column). Existing sale history is not
          // carried forward — this is a clean cut, not a data migration.
          // deleteTable() is DROP TABLE IF EXISTS, so it's safe to call
          // even for a fresh v1 -> v3 upgrade where the old sales table
          // was never created in the first place.
          if (from < 3) {
            await m.deleteTable('silver_plus_sales');
            await m.createTable(silverPlusAllocations);
          }
        },
      );

  // ---------------- Item groups ----------------

  Stream<List<ItemGroup>> watchItemGroups() => select(itemGroups).watch();

  Future<ItemGroup> itemGroupByName(String name) =>
      (select(itemGroups)..where((t) => t.name.equals(name))).getSingle();

  // ---------------- Item types ----------------

  Stream<List<ItemType>> watchItemTypes(int groupId) {
    final query = select(itemTypes)..where((t) => t.itemGroupId.equals(groupId));
    query.orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch();
  }

  /// Live count of item types belonging to a group (used for the
  /// "Gold (Count: N)" / "Silver (Count: N)" toggle labels).
  Stream<int> watchItemTypeCount(int groupId) {
    final query = selectOnly(itemTypes)
      ..addColumns([itemTypes.id.count()])
      ..where(itemTypes.itemGroupId.equals(groupId));
    return query.map((row) => row.read(itemTypes.id.count()) ?? 0).watchSingle();
  }

  Future<int> addItemType(int groupId, String name) {
    return into(itemTypes).insert(
      ItemTypesCompanion.insert(itemGroupId: groupId, name: name),
    );
  }

  Future<bool> renameItemType(int id, String newName) {
    return (update(itemTypes)..where((t) => t.id.equals(id)))
        .write(ItemTypesCompanion(name: Value(newName)))
        .then((rows) => rows > 0);
  }

  Future<int> countOrnamentsOfType(int itemTypeId) {
    final query = selectOnly(ornaments)
      ..addColumns([ornaments.id.count()])
      ..where(ornaments.itemTypeId.equals(itemTypeId));
    return query
        .map((row) => row.read(ornaments.id.count()) ?? 0)
        .getSingle();
  }

  Future<int> deleteItemType(int id) =>
      (delete(itemTypes)..where((t) => t.id.equals(id))).go();

  // ---------------- Ornaments ----------------

  Stream<List<Ornament>> watchOrnaments({
    required int groupId,
    OrnamentStatus? status,
    int? itemTypeId,
    String? searchTerm,
  }) {
    final query = select(ornaments)..where((t) => t.itemGroupId.equals(groupId));
    if (status != null) {
      query.where((t) => t.status.equalsValue(status));
    }
    if (itemTypeId != null) {
      query.where((t) => t.itemTypeId.equals(itemTypeId));
    }
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      query.where((t) => t.ornamentCode.like('%${searchTerm.trim()}%'));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch();
  }

  Future<bool> isOrnamentCodeTaken(int groupId, String code, {int? excludingId}) async {
    final query = select(ornaments)
      ..where((t) => t.itemGroupId.equals(groupId) & t.ornamentCode.equals(code));
    if (excludingId != null) {
      query.where((t) => t.id.equals(excludingId).not());
    }
    final match = await query.getSingleOrNull();
    return match != null;
  }

  Future<int> addOrnament(OrnamentsCompanion companion) =>
      into(ornaments).insert(companion);

  Future<bool> updateOrnament(int id, OrnamentsCompanion companion) {
    return (update(ornaments)..where((t) => t.id.equals(id)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  Future<int> deleteOrnament(int id) =>
      (delete(ornaments)..where((t) => t.id.equals(id))).go();

  /// Updates status + writes a StatusHistories row in one transaction.
  Future<void> changeStatus({
    required int ornamentId,
    required OrnamentStatus newStatus,
    required DateTime date,
    String? customerName,
  }) async {
    await transaction(() async {
      await (update(ornaments)..where((t) => t.id.equals(ornamentId))).write(
        OrnamentsCompanion(
          status: Value(newStatus),
          statusDate: Value(date),
          customerName: Value(newStatus == OrnamentStatus.pending ? customerName : null),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await into(statusHistories).insert(
        StatusHistoriesCompanion.insert(
          ornamentId: ornamentId,
          status: newStatus,
          date: date,
          customerName: Value(newStatus == OrnamentStatus.pending ? customerName : null),
        ),
      );
    });
  }

  // ---------------- Summary (Ornaments) ----------------

  /// Type-wise rollup: count + total weight, filtered by group and
  /// optional status (e.g. "Available" summary view). Live-updating so
  /// the Summary screen reflects ornament/status changes immediately.
  Stream<List<TypeSummaryRow>> watchTypeSummary({
    required int groupId,
    OrnamentStatus? status,
  }) {
    final countExpr = ornaments.id.count();
    final weightExpr = ornaments.weightGrams.sum();

    final query = selectOnly(ornaments).join([
      innerJoin(itemTypes, itemTypes.id.equalsExp(ornaments.itemTypeId)),
    ])
      ..addColumns([itemTypes.id, itemTypes.name, countExpr, weightExpr])
      ..where(ornaments.itemGroupId.equals(groupId))
      ..groupBy([itemTypes.id]);

    if (status != null) {
      query.where(ornaments.status.equalsValue(status));
    }

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => TypeSummaryRow(
                  typeId: row.read(itemTypes.id)!,
                  typeName: row.read(itemTypes.name) ?? '',
                  count: row.read(countExpr) ?? 0,
                  totalWeight: row.read(weightExpr) ?? 0,
                ),
              )
              .toList(),
        );
  }

  /// Type-wise rollup: count + total weight, filtered by group and
  /// optional status (e.g. "Available" summary view).
  Future<List<TypeSummaryRow>> typeSummary({
    required int groupId,
    OrnamentStatus? status,
  }) async {
    final countExpr = ornaments.id.count();
    final weightExpr = ornaments.weightGrams.sum();

    final query = selectOnly(ornaments).join([
      innerJoin(itemTypes, itemTypes.id.equalsExp(ornaments.itemTypeId)),
    ])
      ..addColumns([itemTypes.id, itemTypes.name, countExpr, weightExpr])
      ..where(ornaments.itemGroupId.equals(groupId))
      ..groupBy([itemTypes.id]);

    if (status != null) {
      query.where(ornaments.status.equalsValue(status));
    }

    final rows = await query.get();
    return rows
        .map(
          (row) => TypeSummaryRow(
            typeId: row.read(itemTypes.id)!,
            typeName: row.read(itemTypes.name) ?? '',
            count: row.read(countExpr) ?? 0,
            totalWeight: row.read(weightExpr) ?? 0,
          ),
        )
        .toList();
  }

  // ---------------- Silver+ : Boxes ----------------

  /// Boxes with count > 0, i.e. still have stock. Optionally filtered
  /// by a Box ID search term.
  Stream<List<SilverPlusBox>> watchAvailableBoxes({String? searchTerm}) {
    final query = select(silverPlusBoxes)..where((t) => t.count.isBiggerThanValue(0));
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      query.where((t) => t.boxCode.like('%${searchTerm.trim()}%'));
    }
    query.orderBy([(t) => OrderingTerm.desc(t.updatedAt)]);
    return query.watch();
  }

  Future<bool> isBoxCodeTaken(String code, {int? excludingId}) async {
    final query = select(silverPlusBoxes)..where((t) => t.boxCode.equals(code));
    if (excludingId != null) {
      query.where((t) => t.id.equals(excludingId).not());
    }
    final match = await query.getSingleOrNull();
    return match != null;
  }

  Future<int> addBox(SilverPlusBoxesCompanion companion) =>
      into(silverPlusBoxes).insert(companion);

  Future<bool> updateBox(int id, SilverPlusBoxesCompanion companion) {
    return (update(silverPlusBoxes)..where((t) => t.id.equals(id)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  /// Count of allocation rows (Pending + Sold combined) against a box —
  /// used to block box deletion if it has any history, regardless of
  /// which status those rows are currently in.
  Future<int> countAllocationsOfBox(int boxId) {
    final query = selectOnly(silverPlusAllocations)
      ..addColumns([silverPlusAllocations.id.count()])
      ..where(silverPlusAllocations.boxId.equals(boxId));
    return query.map((row) => row.read(silverPlusAllocations.id.count()) ?? 0).getSingle();
  }

  Future<int> deleteBox(int id) =>
      (delete(silverPlusBoxes)..where((t) => t.id.equals(id))).go();

  /// A single box by id — used when editing/converting an allocation,
  /// where the allocation row only carries boxId/boxCode and the
  /// current live box needs to be fetched separately.
  Future<SilverPlusBox> boxById(int id) =>
      (select(silverPlusBoxes)..where((t) => t.id.equals(id))).getSingle();

  // ---------------- Silver+ : Allocations (Pending / Sold) ----------------

  /// Pending or Sold rows (per [status]), newest first, joined with the
  /// box code for display. Optionally filtered by a Box ID search term.
  Stream<List<SilverPlusAllocationRow>> watchAllocations({
    required AllocationStatus status,
    String? searchTerm,
  }) {
    final query = select(silverPlusAllocations).join([
      innerJoin(silverPlusBoxes, silverPlusBoxes.id.equalsExp(silverPlusAllocations.boxId)),
    ])
      ..where(silverPlusAllocations.status.equalsValue(status));
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      query.where(silverPlusBoxes.boxCode.like('%${searchTerm.trim()}%'));
    }
    query.orderBy([OrderingTerm.desc(silverPlusAllocations.date)]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => SilverPlusAllocationRow(
                  id: row.readTable(silverPlusAllocations).id,
                  boxId: row.readTable(silverPlusAllocations).boxId,
                  boxCode: row.readTable(silverPlusBoxes).boxCode,
                  count: row.readTable(silverPlusAllocations).count,
                  weightGrams: row.readTable(silverPlusAllocations).weightGrams,
                  date: row.readTable(silverPlusAllocations).date,
                  customerName: row.readTable(silverPlusAllocations).customerName,
                  status: row.readTable(silverPlusAllocations).status,
                ),
              )
              .toList(),
        );
  }

  /// Moves a chunk OUT of Available into Pending or Sold: blocks the
  /// move if [count] or [weightGrams] exceeds what's currently in the
  /// box. Returns true on success, false if there wasn't enough stock.
  Future<bool> allocateFromBox({
    required int boxId,
    required int count,
    required double weightGrams,
    required DateTime date,
    required AllocationStatus status,
    String? customerName,
  }) async {
    return transaction(() async {
      final box = await (select(silverPlusBoxes)..where((t) => t.id.equals(boxId))).getSingle();

      if (count > box.count || weightGrams > box.weightGrams) {
        return false;
      }

      await (update(silverPlusBoxes)..where((t) => t.id.equals(boxId))).write(
        SilverPlusBoxesCompanion(
          count: Value(box.count - count),
          weightGrams: Value(box.weightGrams - weightGrams),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await into(silverPlusAllocations).insert(
        SilverPlusAllocationsCompanion.insert(
          boxId: boxId,
          count: count,
          weightGrams: weightGrams,
          date: date,
          status: Value(status),
          customerName: Value(status == AllocationStatus.pending ? customerName : null),
        ),
      );
      return true;
    });
  }

  /// Edits an existing allocation's count/weight/date/customer, and
  /// optionally flips its status between pending and sold (pass
  /// [newStatus]; omit it — or pass the row's current status — to leave
  /// status unchanged). The box was already deducted once when the row
  /// was first created, and stays deducted regardless of whether the
  /// row is pending or sold — so a pending<->sold flip never touches
  /// the box on its own. Only the count/weight delta (old amounts
  /// reverted, new amounts re-applied) can change the box here. Returns
  /// true on success, false if the new amounts don't fit.
  Future<bool> updateAllocation({
    required int allocationId,
    required int newCount,
    required double newWeightGrams,
    required DateTime newDate,
    String? newCustomerName,
    AllocationStatus? newStatus,
  }) async {
    return transaction(() async {
      final allocation =
          await (select(silverPlusAllocations)..where((t) => t.id.equals(allocationId))).getSingle();
      final box =
          await (select(silverPlusBoxes)..where((t) => t.id.equals(allocation.boxId))).getSingle();

      final effectiveCount = box.count + allocation.count;
      final effectiveWeight = box.weightGrams + allocation.weightGrams;

      if (newCount > effectiveCount || newWeightGrams > effectiveWeight) {
        return false;
      }

      final resolvedStatus = newStatus ?? allocation.status;

      await (update(silverPlusBoxes)..where((t) => t.id.equals(box.id))).write(
        SilverPlusBoxesCompanion(
          count: Value(effectiveCount - newCount),
          weightGrams: Value(effectiveWeight - newWeightGrams),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await (update(silverPlusAllocations)..where((t) => t.id.equals(allocationId))).write(
        SilverPlusAllocationsCompanion(
          count: Value(newCount),
          weightGrams: Value(newWeightGrams),
          date: Value(newDate),
          status: Value(resolvedStatus),
          customerName: Value(resolvedStatus == AllocationStatus.pending ? newCustomerName : null),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return true;
    });
  }

  /// Moves a row back to Available: deletes the allocation and restocks
  /// the box with its count/weight. Valid from either Pending or Sold.
  Future<void> revertAllocationToAvailable(int allocationId) async {
    await transaction(() async {
      final allocation =
          await (select(silverPlusAllocations)..where((t) => t.id.equals(allocationId))).getSingle();
      final box =
          await (select(silverPlusBoxes)..where((t) => t.id.equals(allocation.boxId))).getSingle();

      await (update(silverPlusBoxes)..where((t) => t.id.equals(box.id))).write(
        SilverPlusBoxesCompanion(
          count: Value(box.count + allocation.count),
          weightGrams: Value(box.weightGrams + allocation.weightGrams),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await (delete(silverPlusAllocations)..where((t) => t.id.equals(allocationId))).go();
    });
  }

  /// Hard-deletes a Sold allocation. Does NOT restock the box — the
  /// sold count/weight stays gone from the box, only the sale record is
  /// removed. Only valid for Sold rows; Pending rows must go through
  /// [revertAllocationToAvailable] instead (there's no direct-delete
  /// path for Pending).
  Future<int> deleteAllocation(int allocationId) async {
    final allocation =
        await (select(silverPlusAllocations)..where((t) => t.id.equals(allocationId))).getSingle();
    if (allocation.status != AllocationStatus.sold) {
      throw StateError(
        'Only Sold allocations can be deleted directly — Pending rows must be '
        'moved back to Available instead.',
      );
    }
    return (delete(silverPlusAllocations)..where((t) => t.id.equals(allocationId))).go();
  }

  /// Adds [addCount]/[addWeightGrams] on top of a box's current live
  /// values. No history is kept for refills.
  Future<void> refillBox({
    required int boxId,
    required int addCount,
    required double addWeightGrams,
  }) async {
    final box = await (select(silverPlusBoxes)..where((t) => t.id.equals(boxId))).getSingle();
    await (update(silverPlusBoxes)..where((t) => t.id.equals(boxId))).write(
      SilverPlusBoxesCompanion(
        count: Value(box.count + addCount),
        weightGrams: Value(box.weightGrams + addWeightGrams),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  // ---------------- Old Silver ----------------

  Stream<List<OldSilverEntry>> watchOldSilverEntries() {
    final query = select(oldSilverEntries)
      ..orderBy([(t) => OrderingTerm.desc(t.entryDate)]);
    return query.watch();
  }

  /// Live running total weight across every entry.
  Stream<double> watchOldSilverTotalWeight() {
    final query = selectOnly(oldSilverEntries)
      ..addColumns([oldSilverEntries.weightGrams.sum()]);
    return query
        .map((row) => row.read(oldSilverEntries.weightGrams.sum()) ?? 0)
        .watchSingle();
  }

  Future<int> addOldSilverEntry(OldSilverEntriesCompanion companion) =>
      into(oldSilverEntries).insert(companion);

  Future<bool> updateOldSilverEntry(int id, OldSilverEntriesCompanion companion) {
    return (update(oldSilverEntries)..where((t) => t.id.equals(id)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  Future<int> deleteOldSilverEntry(int id) =>
      (delete(oldSilverEntries)..where((t) => t.id.equals(id))).go();

  /// Hard-deletes every entry — "Scrap All, make it clean".
  Future<int> scrapAllOldSilver() => delete(oldSilverEntries).go();

  static QueryExecutor _openConnection(String dbFilePath) {
    return LazyDatabase(() async {
      final file = File(dbFilePath);
      if (!file.parent.existsSync()) {
        file.parent.createSync(recursive: true);
      }
      return NativeDatabase.createInBackground(file);
    });
  }
}

class TypeSummaryRow {
  TypeSummaryRow({
    required this.typeId,
    required this.typeName,
    required this.count,
    required this.totalWeight,
  });

  final int typeId;
  final String typeName;
  final int count;
  final double totalWeight;
}

/// An allocation (Pending or Sold chunk) joined with its box's code,
/// for display in the Silver+ Pending/Sold tabs. Carries [id]/[boxId]
/// so the row can be edited, converted to the other status, reverted to
/// Available, or (Sold only) deleted from the UI.
class SilverPlusAllocationRow {
  SilverPlusAllocationRow({
    required this.id,
    required this.boxId,
    required this.boxCode,
    required this.count,
    required this.weightGrams,
    required this.date,
    required this.customerName,
    required this.status,
  });

  final int id;
  final int boxId;
  final String boxCode;
  final int count;
  final double weightGrams;
  final DateTime date;
  final String? customerName;
  final AllocationStatus status;
}
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/item_groups_table.dart';
import 'tables/item_types_table.dart';
import 'tables/ornaments_table.dart';
import 'tables/status_history_table.dart';
import 'tables/silver_plus_boxes_table.dart';
import 'tables/silver_plus_sales_table.dart';
import 'tables/old_silver_entries_table.dart';

export 'tables/ornaments_table.dart' show OrnamentStatus;

part 'app_database.g.dart';

@DriftDatabase(tables: [
  ItemGroups,
  ItemTypes,
  Ornaments,
  StatusHistories,
  SilverPlusBoxes,
  SilverPlusSales,
  OldSilverEntries,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String dbFilePath) : super(_openConnection(dbFilePath));

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(itemGroups).insert(const ItemGroupsCompanion(name: Value('Gold')));
          await into(itemGroups).insert(const ItemGroupsCompanion(name: Value('Silver')));
        },
        onUpgrade: (m, from, to) async {
          // v1 -> v2: adds Silver+ and Old Silver. Purely additive — no
          // existing table (ItemGroups/ItemTypes/Ornaments/StatusHistories)
          // is touched, so existing client data is unaffected.
          if (from < 2) {
            await m.createTable(silverPlusBoxes);
            await m.createTable(silverPlusSales);
            await m.createTable(oldSilverEntries);
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
    String? searchTerm,
  }) {
    final query = select(ornaments)..where((t) => t.itemGroupId.equals(groupId));
    if (status != null) {
      query.where((t) => t.status.equalsValue(status));
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
      ..addColumns([itemTypes.name, countExpr, weightExpr])
      ..where(ornaments.itemGroupId.equals(groupId))
      ..groupBy([itemTypes.id]);

    if (status != null) {
      query.where(ornaments.status.equalsValue(status));
    }

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => TypeSummaryRow(
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
      ..addColumns([itemTypes.name, countExpr, weightExpr])
      ..where(ornaments.itemGroupId.equals(groupId))
      ..groupBy([itemTypes.id]);

    if (status != null) {
      query.where(ornaments.status.equalsValue(status));
    }

    final rows = await query.get();
    return rows
        .map(
          (row) => TypeSummaryRow(
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

  Future<int> countSalesOfBox(int boxId) {
    final query = selectOnly(silverPlusSales)
      ..addColumns([silverPlusSales.id.count()])
      ..where(silverPlusSales.boxId.equals(boxId));
    return query.map((row) => row.read(silverPlusSales.id.count()) ?? 0).getSingle();
  }

  Future<int> deleteBox(int id) =>
      (delete(silverPlusBoxes)..where((t) => t.id.equals(id))).go();

  /// A single box by id — used when editing a sale, where the sale row
  /// only carries the boxId/boxCode and the current live box needs to be
  /// fetched separately.
  Future<SilverPlusBox> boxById(int id) =>
      (select(silverPlusBoxes)..where((t) => t.id.equals(id))).getSingle();

  // ---------------- Silver+ : Sales ----------------

  /// Sold transactions, newest first, joined with the box code for
  /// display. Optionally filtered by a Box ID search term.
  Stream<List<SilverPlusSaleRow>> watchSales({String? searchTerm}) {
    final query = select(silverPlusSales).join([
      innerJoin(silverPlusBoxes, silverPlusBoxes.id.equalsExp(silverPlusSales.boxId)),
    ]);
    if (searchTerm != null && searchTerm.trim().isNotEmpty) {
      query.where(silverPlusBoxes.boxCode.like('%${searchTerm.trim()}%'));
    }
    query.orderBy([OrderingTerm.desc(silverPlusSales.saleDate)]);

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => SilverPlusSaleRow(
                  id: row.readTable(silverPlusSales).id,
                  boxId: row.readTable(silverPlusSales).boxId,
                  boxCode: row.readTable(silverPlusBoxes).boxCode,
                  countSold: row.readTable(silverPlusSales).countSold,
                  weightSoldGrams: row.readTable(silverPlusSales).weightSoldGrams,
                  saleDate: row.readTable(silverPlusSales).saleDate,
                ),
              )
              .toList(),
        );
  }

  /// Records a sale against a box: blocks the sale if [countSold] or
  /// [weightSoldGrams] exceeds what's currently in the box. Returns
  /// true on success, false if there wasn't enough stock.
  Future<bool> sellFromBox({
    required int boxId,
    required int countSold,
    required double weightSoldGrams,
    required DateTime saleDate,
  }) async {
    return transaction(() async {
      final box = await (select(silverPlusBoxes)..where((t) => t.id.equals(boxId))).getSingle();

      if (countSold > box.count || weightSoldGrams > box.weightGrams) {
        return false;
      }

      await (update(silverPlusBoxes)..where((t) => t.id.equals(boxId))).write(
        SilverPlusBoxesCompanion(
          count: Value(box.count - countSold),
          weightGrams: Value(box.weightGrams - weightSoldGrams),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await into(silverPlusSales).insert(
        SilverPlusSalesCompanion.insert(
          boxId: boxId,
          countSold: countSold,
          weightSoldGrams: weightSoldGrams,
          saleDate: saleDate,
        ),
      );
      return true;
    });
  }

  /// Edits an existing sale in place (box itself can't be changed via
  /// edit). Reverts the sale's old count/weight back onto the box first
  /// — so the validation ceiling is "what's available if this sale had
  /// never happened" — then validates and re-applies the new amounts.
  /// Returns true on success, false if the new amounts don't fit.
  Future<bool> updateSale({
    required int saleId,
    required int newCountSold,
    required double newWeightSoldGrams,
    required DateTime newSaleDate,
  }) async {
    return transaction(() async {
      final sale = await (select(silverPlusSales)..where((t) => t.id.equals(saleId))).getSingle();
      final box = await (select(silverPlusBoxes)..where((t) => t.id.equals(sale.boxId))).getSingle();

      final effectiveCount = box.count + sale.countSold;
      final effectiveWeight = box.weightGrams + sale.weightSoldGrams;

      if (newCountSold > effectiveCount || newWeightSoldGrams > effectiveWeight) {
        return false;
      }

      await (update(silverPlusBoxes)..where((t) => t.id.equals(box.id))).write(
        SilverPlusBoxesCompanion(
          count: Value(effectiveCount - newCountSold),
          weightGrams: Value(effectiveWeight - newWeightSoldGrams),
          updatedAt: Value(DateTime.now()),
        ),
      );
      await (update(silverPlusSales)..where((t) => t.id.equals(saleId))).write(
        SilverPlusSalesCompanion(
          countSold: Value(newCountSold),
          weightSoldGrams: Value(newWeightSoldGrams),
          saleDate: Value(newSaleDate),
        ),
      );
      return true;
    });
  }

  /// Deletes a sale record only. Does NOT restock the box — the sold
  /// count/weight stays gone from the box, only the sale history entry
  /// is removed.
  Future<int> deleteSale(int saleId) =>
      (delete(silverPlusSales)..where((t) => t.id.equals(saleId))).go();

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
    required this.typeName,
    required this.count,
    required this.totalWeight,
  });

  final String typeName;
  final int count;
  final double totalWeight;
}

/// A sale transaction joined with its box's code, for display in the
/// Silver+ "Sold" tab. Carries [id]/[boxId] so the row can be edited or
/// deleted from the UI.
class SilverPlusSaleRow {
  SilverPlusSaleRow({
    required this.id,
    required this.boxId,
    required this.boxCode,
    required this.countSold,
    required this.weightSoldGrams,
    required this.saleDate,
  });

  final int id;
  final int boxId;
  final String boxCode;
  final int countSold;
  final double weightSoldGrams;
  final DateTime saleDate;
}
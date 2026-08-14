import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';

import 'tables/item_groups_table.dart';
import 'tables/item_types_table.dart';
import 'tables/ornaments_table.dart';
import 'tables/status_history_table.dart';

export 'tables/ornaments_table.dart' show OrnamentStatus;

part 'app_database.g.dart';

@DriftDatabase(tables: [ItemGroups, ItemTypes, Ornaments, StatusHistories])
class AppDatabase extends _$AppDatabase {
  AppDatabase(String dbFilePath) : super(_openConnection(dbFilePath));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await into(itemGroups).insert(const ItemGroupsCompanion(name: Value('Gold')));
          await into(itemGroups).insert(const ItemGroupsCompanion(name: Value('Silver')));
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

  // ---------------- Summary ----------------

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
import 'package:drift/drift.dart';
import 'item_groups_table.dart';

/// User-managed item types (e.g. "Chain", "Ring", "Bangle"),
/// scoped to a single item group.
class ItemTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemGroupId => integer().references(ItemGroups, #id)();
  TextColumn get name => text().withLength(min: 1, max: 50)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {itemGroupId, name},
      ];
}

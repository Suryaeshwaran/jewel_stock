import 'package:drift/drift.dart';
import 'item_groups_table.dart';
import 'item_types_table.dart';

/// available -> default on create
/// sold      -> can revert back to available
/// pending   -> reserved for a customer (free-text name)
/// scrapped  -> terminal, no revert
enum OrnamentStatus { available, sold, pending, scrapped }

class Ornaments extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// User-facing alphanumeric code. Unique per item group (not globally).
  TextColumn get ornamentCode => text().withLength(min: 1, max: 40)();

  IntColumn get itemGroupId => integer().references(ItemGroups, #id)();
  IntColumn get itemTypeId => integer().references(ItemTypes, #id)();

  RealColumn get weightGrams => real()();

  /// Date the ornament was added to stock (today, editable via picker).
  DateTimeColumn get entryDate => dateTime()();

  TextColumn get status =>
      textEnum<OrnamentStatus>().withDefault(const Constant('available'))();

  /// Date of the most recent status change (sold/pending/scrapped date).
  DateTimeColumn get statusDate => dateTime().nullable()();

  /// Free-text customer name, only meaningful while status == pending.
  TextColumn get customerName => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
        {itemGroupId, ornamentCode},
      ];
}

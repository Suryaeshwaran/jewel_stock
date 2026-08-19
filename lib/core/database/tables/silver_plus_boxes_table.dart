import 'package:drift/drift.dart';

/// A bulk "box" of silver items. Unlike Ornaments, there's no
/// group/type dimension here — just a code, and the box's current
/// live count/weight. Selling reduces these; refilling increases them.
@DataClassName('SilverPlusBox')
class SilverPlusBoxes extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Alphanumeric, forced uppercase in the UI, unique within this table.
  TextColumn get boxCode => text().withLength(min: 1, max: 40).unique()();

  IntColumn get count => integer()();
  RealColumn get weightGrams => real()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
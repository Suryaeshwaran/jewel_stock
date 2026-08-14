import 'package:drift/drift.dart';

/// Fixed set of groups: Gold, Silver. Seeded on first create — not
/// user-creatable, but kept as a table (not an enum) so it can be
/// extended later without a schema rewrite.
class ItemGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 30).unique()();
}

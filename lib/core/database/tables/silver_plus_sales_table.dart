import 'package:drift/drift.dart';
import 'silver_plus_boxes_table.dart';

/// Append-only log: one row per sale (partial or full) against a box.
/// A box can appear here multiple times as it's sold down in batches.
/// The "Sold" list is a straight read of this table, newest first.
@DataClassName('SilverPlusSale')
class SilverPlusSales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get boxId => integer().references(SilverPlusBoxes, #id)();

  IntColumn get countSold => integer()();
  RealColumn get weightSoldGrams => real()();
  DateTimeColumn get saleDate => dateTime()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
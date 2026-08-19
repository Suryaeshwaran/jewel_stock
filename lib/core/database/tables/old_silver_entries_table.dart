import 'package:drift/drift.dart';

/// A flat, ungrouped running ledger — user keeps adding weight/date
/// entries over time; the screen shows a live running total. "Scrap
/// All" hard-deletes every row and starts fresh.
@DataClassName('OldSilverEntry')
class OldSilverEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  RealColumn get weightGrams => real()();
  DateTimeColumn get entryDate => dateTime()();
  TextColumn get note => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
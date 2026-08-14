import 'package:drift/drift.dart';
import 'ornaments_table.dart';

/// Append-only trail of every status change on an ornament — useful for
/// later reporting (e.g. "sold this month") even though the ornament row
/// itself only carries the current status.
class StatusHistories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get ornamentId => integer().references(Ornaments, #id)();
  TextColumn get status => textEnum<OrnamentStatus>()();
  DateTimeColumn get date => dateTime()();
  TextColumn get customerName => text().nullable()();
  DateTimeColumn get recordedAt => dateTime().withDefault(currentDateAndTime)();
}

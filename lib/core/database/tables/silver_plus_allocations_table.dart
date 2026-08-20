import 'package:drift/drift.dart';
import 'silver_plus_boxes_table.dart';

/// pending -> reserved for a customer; count/weight already deducted
///            from the box
/// sold    -> finalized sale; count/weight already deducted from the
///            box
///
/// There is no 'available' value here. An "available" chunk simply
/// isn't a row in this table at all — it's still part of the box's own
/// live count/weight. A row only comes into existence once a chunk
/// moves OUT of Available into Pending or Sold, and is deleted again if
/// it moves back to Available.
enum AllocationStatus { pending, sold }

/// One row per chunk taken out of a box, either reserved for a
/// customer (pending) or finalized as a sale (sold). Pending and Sold
/// are structurally identical — both represent stock already deducted
/// from the box — so they share this one table and move freely between
/// each other via a status flip (no box adjustment needed, since the
/// stock was already taken out at creation time). Only reverting a row
/// back to Available deletes it here and restocks the box.
@DataClassName('SilverPlusAllocation')
class SilverPlusAllocations extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get boxId => integer().references(SilverPlusBoxes, #id)();

  IntColumn get count => integer()();
  RealColumn get weightGrams => real()();
  DateTimeColumn get date => dateTime()();

  TextColumn get status =>
      textEnum<AllocationStatus>().withDefault(const Constant('pending'))();

  /// Free-text customer name, only meaningful while status == pending.
  TextColumn get customerName => text().nullable()();

  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

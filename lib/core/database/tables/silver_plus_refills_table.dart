import 'package:drift/drift.dart';

import 'silver_plus_boxes_table.dart';

/// Log of stock added to an existing Silver+ box via the Refill action
/// on the Silver+ screen. This is intentionally NOT surfaced anywhere
/// in the UI as a browsable history (refills stay "silent" on the box
/// itself, per RefillDialog's docs) — it exists solely so the Reports
/// > Available tab can show a refill on the day it happened, instead
/// of the added stock being invisible to reporting.
class SilverPlusRefills extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get boxId => integer().references(SilverPlusBoxes, #id)();
  IntColumn get addCount => integer()();
  RealColumn get addWeightGrams => real()();
  DateTimeColumn get refillDate => dateTime()();
}

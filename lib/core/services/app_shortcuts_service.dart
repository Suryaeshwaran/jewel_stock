import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_keys.dart';
import '../database/app_database.dart';
import '../../features/item_type/presentation/widgets/item_type_dialog.dart';

/// Handlers for global keyboard shortcuts, wired up in
/// `JewelStockApp`'s `MaterialApp.builder`. Kept separate from
/// `app.dart` so new shortcuts can be added here later without
/// cluttering the app shell.
class AppShortcutsService {
  AppShortcutsService._();

  /// Opens the "Add Item Type" dialog pre-scoped to [groupName]
  /// ('Gold' or 'Silver') — the same flow as the "Add Item Type"
  /// button on the Item Type Management screen. Triggered via
  /// Ctrl/Cmd+Shift+G (Gold) or Ctrl/Cmd+Shift+S (Silver), from
  /// anywhere in the app.
  static Future<void> addItemType(String groupName) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final db = Provider.of<AppDatabase>(context, listen: false);
    final group = await db.itemGroupByName(groupName);

    // One-shot read of the current type list, reusing the existing
    // watch stream rather than adding a new DB query.
    final existingTypes = await db.watchItemTypes(group.id).first;
    final existingLower = existingTypes.map((t) => t.name.toLowerCase()).toSet();

    // Re-fetch the context after the await in case the tree changed.
    final dialogContext = navigatorKey.currentContext;
    if (dialogContext == null) return;

    final name = await showDialog<String>(
      context: dialogContext,
      builder: (_) => ItemTypeDialog(
        groupLabel: groupName,
        existingNamesLower: existingLower,
      ),
    );
    if (name == null) return;

    await db.addItemType(group.id, name);

    scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text('Added "$name" to $groupName')),
    );
  }
}

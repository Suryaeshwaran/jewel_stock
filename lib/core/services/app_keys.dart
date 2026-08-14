import 'package:flutter/material.dart';

/// Global keys giving access to the Navigator and ScaffoldMessenger from
/// outside the widget tree.
///
/// This is needed because keyboard-shortcut callbacks are wired up in
/// [MaterialApp.builder], whose `context` sits *above* the Navigator —
/// so `showDialog`/`Navigator.of(context)` can't be called with it
/// directly. Using these keys is the standard Flutter pattern for
/// triggering UI (dialogs, snackbars) from outside the normal widget
/// tree, e.g. from a global shortcut or a background service.
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

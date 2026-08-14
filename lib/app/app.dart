import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../core/services/app_keys.dart';
import '../core/services/app_shortcuts_service.dart';

class JewelStockApp extends StatelessWidget {
  const JewelStockApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JewelStock',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      navigatorKey: navigatorKey,
      scaffoldMessengerKey: scaffoldMessengerKey,
      home: const DashboardScreen(),
      builder: (context, child) {
        // Global keyboard shortcuts, active regardless of which screen
        // is on top. Both Ctrl and Cmd are bound to the same action so
        // this feels native on Windows (prod) and macOS (dev) alike.
        return CallbackShortcuts(
          bindings: <ShortcutActivator, VoidCallback>{
            const SingleActivator(LogicalKeyboardKey.keyG, control: true, shift: true):
                () => AppShortcutsService.addItemType('Gold'),
            const SingleActivator(LogicalKeyboardKey.keyG, meta: true, shift: true):
                () => AppShortcutsService.addItemType('Gold'),
            const SingleActivator(LogicalKeyboardKey.keyS, control: true, shift: true):
                () => AppShortcutsService.addItemType('Silver'),
            const SingleActivator(LogicalKeyboardKey.keyS, meta: true, shift: true):
                () => AppShortcutsService.addItemType('Silver'),
          },
          child: Focus(
            autofocus: true,
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
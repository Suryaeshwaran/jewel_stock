// Basic smoke test: verifies the app boots without throwing.
//
// The default Flutter template test referenced a `MyApp` counter widget
// that no longer exists in this project. The real entry point is
// `JewelStockBootstrap`, which resolves the database path (including a
// first-run folder picker) before handing off to `JewelStockApp`.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:jewel_stock/main.dart';

void main() {
  testWidgets('App boots and shows the boot loading screen', (WidgetTester tester) async {
    await tester.pumpWidget(const JewelStockBootstrap());

    // Before the DB path resolves, we should at least get a MaterialApp
    // with no exceptions thrown.
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
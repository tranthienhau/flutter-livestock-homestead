import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_livestock_homestead/main.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  Future<void> shoot(WidgetTester tester, String name) async {
    await binding.convertFlutterSurfaceToImage();
    await tester.pumpAndSettle();
    await binding.takeScreenshot(name);
  }

  setUpAll(() async {
    await Hive.initFlutter();
    for (final box in [
      'animals',
      'health_logs',
      'production',
      'finance',
      'savings',
    ]) {
      if (!Hive.isBoxOpen(box)) {
        await Hive.openBox(box);
      }
    }
  });

  testWidgets('capture homestead flow', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: HomesteadApp()));
    await tester.pumpAndSettle();
    await shoot(tester, '01-home');

    // Finance dashboard (account_balance_wallet icon in the app bar).
    await tester.tap(find.byIcon(Icons.account_balance_wallet));
    await tester.pumpAndSettle();
    await shoot(tester, '02-finance');

    // Back to home, then open the savings goal screen.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.savings));
    await tester.pumpAndSettle();
    await shoot(tester, '03-savings');

    // Back to home and open an animal detail.
    await tester.pageBack();
    await tester.pumpAndSettle();
    await tester.tap(find.text('Henrietta'));
    await tester.pumpAndSettle();
    await shoot(tester, '04-animal-detail');
  });
}

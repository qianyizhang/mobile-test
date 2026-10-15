import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_calculator/main.dart';

void main() {
  Future<void> press(WidgetTester tester, List<String> keys) async {
    for (final key in keys) {
      await tester.tap(find.byKey(ValueKey('key-$key')));
      await tester.pump();
    }
  }

  String result(WidgetTester tester) =>
      tester.widget<Text>(find.byKey(const ValueKey('display'))).data!;

  testWidgets('tap arithmetic, decimals, error and recovery', (tester) async {
    await tester.pumpWidget(const CalculatorApp());
    expect(result(tester), '0');
    await press(tester, ['0', '.', '1', '+', '0', '.', '2', '=']);
    expect(result(tester), '0.3');
    await press(tester, ['AC', '8', '÷', '0', '=']);
    expect(result(tester).toLowerCase(), contains('error'));
    await press(tester, ['7', '×', '6', '=']);
    expect(result(tester), '42');
  });

  testWidgets('all keys have descriptive accessibility labels', (tester) async {
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(const CalculatorApp());
    expect(find.bySemanticsLabel('Clear all'), findsOneWidget);
    expect(find.bySemanticsLabel('Delete last digit'), findsOneWidget);
    expect(find.bySemanticsLabel('Change sign'), findsOneWidget);
    expect(find.bySemanticsLabel('Equals'), findsOneWidget);
    expect(find.bySemanticsLabel('Result'), findsOneWidget);
    semantics.dispose();
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
  ]) {
    testWidgets('layout and touch targets at $size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(const CalculatorApp());
      expect(tester.takeException(), isNull);
      for (final button in find.byType(FilledButton).evaluate()) {
        final box = button.renderObject! as RenderBox;
        expect(box.size.width, greaterThanOrEqualTo(48));
        expect(box.size.height, greaterThanOrEqualTo(48));
      }
      await press(tester, ['9', '−', '4', '=']);
      expect(result(tester), '5');
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('large accessibility text does not overflow', (tester) async {
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await tester.pumpWidget(const CalculatorApp());
    await press(tester, [
      '9',
      '9',
      '9',
      '9',
      '9',
      '9',
      '9',
      '9',
      '9',
      '9',
      '9',
      '9',
    ]);
    expect(tester.takeException(), isNull);
  });
}

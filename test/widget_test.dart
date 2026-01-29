import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:calculadora_cientifica/main.dart';

void main() {
  testWidgets('Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CalculatorApp());

    // Verify that our calculator starts with 0
    expect(find.text('0'), findsOneWidget);
    expect(find.text('Calculadora Científica'), findsOneWidget);

    // Tap the '1' button
    await tester.tap(find.text('1'));
    await tester.pump();

    // Verify that the display shows 1
    expect(find.text('1'), findsOneWidget);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:imc_app/main.dart';

void main() {
  testWidgets('IMC Calculator UI smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ImcApp());

    // Check for the presence of the main title.
    expect(find.text('Calculateur IMC'), findsOneWidget);

    // Check for input fields.
    expect(find.widgetWithText(TextField, 'Poids (kg)'), findsOneWidget);
    expect(find.widgetWithText(TextField, 'Taille (m)'), findsOneWidget);

    // Check for the calculate button.
    expect(find.widgetWithText(FilledButton, 'Calculer'), findsOneWidget);

    // Check for the initial BMI display (should be '—').
    expect(find.text('—'), findsOneWidget);
  });
}

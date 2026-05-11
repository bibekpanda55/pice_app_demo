import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pice_demo/main.dart';

void main() {
  testWidgets('Suppliers list renders sample suppliers', (tester) async {
    await tester.pumpWidget(const PiceDemoApp());
    await tester.pumpAndSettle();

    expect(find.text('Suppliers'), findsOneWidget);
    expect(find.text('Trashback India Private Limited'), findsOneWidget);
    expect(find.text('Sunrise Pharma Wholesale'), findsOneWidget);
  });

  testWidgets(
      'Tapping a supplier opens the merchant detail screen with the health card',
      (tester) async {
    await tester.pumpWidget(const PiceDemoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Aarav Distributors'));
    await tester.pumpAndSettle();

    expect(find.text('SUPPLIER HEALTH'), findsOneWidget);
    expect(find.text('Worth a second look'), findsOneWidget);
    expect(find.text('Pay Now'), findsOneWidget);
  });

  testWidgets(
      'Receipt icon opens the Invoices screen with All/Pending/Disputed tabs',
      (tester) async {
    await tester.pumpWidget(const PiceDemoApp());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.receipt_long_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Invoices'), findsOneWidget);
    // Tab labels include their counts in parens.
    expect(find.textContaining('All ('), findsOneWidget);
    expect(find.textContaining('Pending ('), findsOneWidget);
    expect(find.textContaining('Disputed ('), findsOneWidget);
  });
}

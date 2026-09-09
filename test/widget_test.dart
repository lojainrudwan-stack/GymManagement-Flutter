// ResortHub Yemen – basic smoke test
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:resort_hub_yemen/main.dart';

void main() {
  testWidgets('ResortHub Yemen app starts without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const ResortHubYemenApp());
    // The welcome screen has two buttons visible
    expect(find.text('ابدأ الاستكشاف'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsAtLeastNWidgets(1));
  });
}

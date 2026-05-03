import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:day35/main.dart';
import 'package:day35/services/storage_service.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await StorageService.instance.init();
    await tester.pumpWidget(const ServinyApp());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}

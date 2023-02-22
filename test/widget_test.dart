// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_exam_app/main.dart';

void main() {
  testWidgets('Product List Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    expect(find.byKey(Key("products_list")), findsOneWidget);
    expect(find.byKey(Key("product_detail")), findsNothing);
    expect(find.byKey(Key("error_widget")), findsNothing);
    await tester.ensureVisible(find.byKey(Key('products_list')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('item_1')));
    expect(find.byKey(Key("product_detail")), findsOneWidget);
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);
    //
    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();
    //
    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}

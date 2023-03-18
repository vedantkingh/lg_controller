import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lg_controller/src/screens/HomePage.dart';
import 'package:lg_controller/src/ui/HomeContent.dart';
import 'package:lg_controller/src/ui/ScreenBackground.dart';
import 'package:lg_controller/src/ui/TitleBar.dart';

void main() {
  testWidgets('Home page component check', (WidgetTester tester) async {
    Widget root = new HomePage(null);
    await tester.pumpWidget(
        new Material(child: new MaterialApp(theme: testTheme(), home: root)));

    expect(find.byType(TitleBar), findsOneWidget);
    expect(find.byType(HomeContent), findsOneWidget);

    Container x = find
        .descendant(of: find.byType(HomePage), matching: find.byType(Container))
        .evaluate()
        .toList()[0]
        .widget;
    expect(x.decoration, ScreenBackground.getBackgroundDecoration());
  });
}

ThemeData testTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.teal,
    cardColor: Colors.white,
    iconTheme: new IconThemeData(
      color: Colors.white,
      opacity: 1.0,
    ),
    fontFamily: 'RobotoMono',
    textTheme: TextTheme(
      displayMedium: TextStyle(
          fontSize: 34, color: Colors.white, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(
          fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(fontSize: 10, color: Colors.white),
      bodyMedium: TextStyle(
          fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold),
    ),
  );
}

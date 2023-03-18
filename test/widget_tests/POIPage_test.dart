import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lg_controller/src/screens/POIPage.dart';
import 'package:lg_controller/src/ui/KMLGridContent.dart';
import 'package:lg_controller/src/ui/NavBar.dart';
import 'package:lg_controller/src/ui/ScreenBackground.dart';
import 'package:lg_controller/src/ui/SearchBar.dart';
import 'package:lg_controller/src/ui/TitleBar.dart';

void main() {
  testWidgets('POI page component check', (WidgetTester tester) async {
    Widget root = new POIPage();
    await tester.pumpWidget(
        new Material(child: new MaterialApp(theme: testTheme(), home: root)));

    expect(find.byType(TitleBar), findsOneWidget);
    expect(find.byType(KMLGridContent), findsOneWidget);
    expect(find.byType(SearchBar), findsOneWidget);
    expect(find.byType(NavBar), findsOneWidget);

    Container x = find
        .descendant(of: find.byType(POIPage), matching: find.byType(Container))
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

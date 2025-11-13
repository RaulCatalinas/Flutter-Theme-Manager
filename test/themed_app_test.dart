import 'package:flutter/material.dart'
    show
        Brightness,
        Builder,
        Colors,
        ElevatedButton,
        MaterialApp,
        Navigator,
        Scaffold,
        Text,
        Theme;
import 'package:flutter_test/flutter_test.dart'
    show WidgetTester, expect, find, findsOneWidget, group, setUp, testWidgets;
import 'package:flutter_theme_manager/flutter_theme_manager.dart'
    show ThemeManager;
import 'package:flutter_theme_manager/themed_app.dart' show ThemedApp;

void main() {
  setUp(() async {
    await ThemeManager.initialize();
  });

  group('ThemedApp', () {
    testWidgets('should build with MaterialApp', (WidgetTester tester) async {
      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          home: Scaffold(body: Text('Home')),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets(
      'should use current theme from ThemeManager',
      (WidgetTester tester) async {
        ThemeManager.setTheme('light');

        await tester.pumpWidget(
          ThemedApp(
            title: 'Test App',
            home: Builder(
              builder: (context) => Scaffold(
                body: Text('Content'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final context = tester.element(find.text('Content'));
        expect(Theme.of(context).brightness, Brightness.light);
      },
    );

    testWidgets(
      'should react to theme changes',
      (WidgetTester tester) async {
        ThemeManager.setTheme('light');

        await tester.pumpWidget(
          ThemedApp(
            title: 'Test App',
            home: Builder(
              builder: (context) => Scaffold(
                body: Text('Content'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        var context = tester.element(find.text('Content'));
        expect(Theme.of(context).brightness, Brightness.light);

        // Change theme
        ThemeManager.setTheme('dark');
        await tester.pumpAndSettle();

        context = tester.element(find.text('Content'));
        expect(Theme.of(context).brightness, Brightness.dark);
      },
    );

    testWidgets(
      'should apply custom theme colors',
      (WidgetTester tester) async {
        ThemeManager.createTheme(
          name: 'custom',
          primaryColor: Colors.purple,
          secondaryColor: Colors.amber,
          brightness: Brightness.light,
        );

        ThemeManager.setTheme('custom');

        await tester.pumpWidget(
          ThemedApp(
            title: 'Test App',
            home: Builder(
              builder: (context) => Scaffold(body: Text('Content')),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final context = tester.element(find.text('Content'));
        expect(Theme.of(context).colorScheme.primary, Colors.purple);
      },
    );

    testWidgets(
      'should apply fontFamily to theme',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          ThemedApp(
            title: 'Test App',
            fontFamily: 'Roboto',
            home: Builder(
              builder: (context) => Scaffold(
                body: Text('Content'),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        final context = tester.element(find.text('Content'));
        expect(Theme.of(context).textTheme.bodyLarge?.fontFamily, 'Roboto');
      },
    );

    testWidgets(
      'should maintain theme during navigation',
      (WidgetTester tester) async {
        ThemeManager.setTheme('dark');

        await tester.pumpWidget(
          ThemedApp(
            title: 'Test App',
            routes: {
              '/': (context) => Scaffold(
                    body: ElevatedButton(
                      onPressed: () => Navigator.pushNamed(context, '/second'),
                      child: Text('Go'),
                    ),
                  ),
              '/second': (context) => Scaffold(
                    body: Text('Second Screen'),
                  ),
            },
          ),
        );

        await tester.pumpAndSettle();

        var context = tester.element(find.text('Go'));
        expect(Theme.of(context).brightness, Brightness.dark);

        await tester.tap(find.text('Go'));
        await tester.pumpAndSettle();

        context = tester.element(find.text('Second Screen'));
        expect(Theme.of(context).brightness, Brightness.dark);
      },
    );
  });
}

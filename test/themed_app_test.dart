import 'package:flutter/material.dart'
    show
        AppBar,
        Brightness,
        BuildContext,
        Builder,
        Colors,
        Column,
        ElevatedButton,
        Icon,
        IconButton,
        Icons,
        Locale,
        MaterialApp,
        Navigator,
        Scaffold,
        Text,
        Theme,
        ThemeData,
        ValueListenableBuilder;
import 'package:flutter_test/flutter_test.dart'
    show
        WidgetTester,
        contains,
        equals,
        expect,
        find,
        findsOneWidget,
        greaterThan,
        group,
        isNot,
        setUp,
        testWidgets;
import 'package:flutter_theme_manager/flutter_theme_manager.dart';
import 'package:flutter_theme_manager/themed_app.dart';

void main() {
  setUp(() async {
    // Initialize ThemeManager before each test
    await ThemeManager.initialize();
  });

  group('ThemedApp - Basic construction', () {
    testWidgets('should build correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          home: Scaffold(
            body: Text('Home'),
          ),
        ),
      );

      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should apply title correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ThemedApp(
          title: 'My Custom App',
          home: Scaffold(body: Text('Content')),
        ),
      );

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.title, 'My Custom App');
    });
  });

  group('ThemedApp - Reactive theme', () {
    testWidgets('should use current theme', (WidgetTester tester) async {
      ThemeManager.setTheme('light');

      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Text(
                  'Content',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      final BuildContext context = tester.element(find.text('Content'));
      expect(Theme.of(context).brightness, Brightness.light);
    });

    testWidgets('should react to theme changes', (WidgetTester tester) async {
      ThemeManager.setTheme('light');

      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          home: Builder(
            builder: (context) {
              final brightness = Theme.of(context).brightness;
              return Scaffold(
                body: Text('Brightness: ${brightness.name}'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial theme
      var context = tester.element(find.byType(Scaffold));
      expect(Theme.of(context).brightness, Brightness.light);
      expect(find.text('Brightness: light'), findsOneWidget);

      // Change theme
      ThemeManager.setTheme('dark');
      await tester.pumpAndSettle();

      // Verify theme changed
      context = tester.element(find.byType(Scaffold));
      expect(Theme.of(context).brightness, Brightness.dark);
      expect(find.text('Brightness: dark'), findsOneWidget);
    });

    testWidgets('should update colors when theme changes',
        (WidgetTester tester) async {
      // Create custom theme
      ThemeManager.createTheme(
        name: 'purple',
        primaryColor: Colors.purple,
        secondaryColor: Colors.amber,
        brightness: Brightness.light,
      );

      ThemeManager.setTheme('light');

      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          home: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(title: Text('Title')),
                body: Text('Content'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      var context = tester.element(find.text('Content'));
      var initialPrimary = Theme.of(context).colorScheme.primary;

      // Change to custom theme
      ThemeManager.setTheme('purple');
      await tester.pumpAndSettle();

      context = tester.element(find.text('Content'));
      var newPrimary = Theme.of(context).colorScheme.primary;

      expect(newPrimary, Colors.purple);
      expect(newPrimary, isNot(equals(initialPrimary)));
    });
  });

  group('ThemedApp - Routes and navigation', () {
    testWidgets('should handle named routes', (WidgetTester tester) async {
      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          initialRoute: '/',
          routes: {
            '/': (context) => Scaffold(body: Text('Home')),
            '/second': (context) => Scaffold(body: Text('Second')),
          },
        ),
      );

      expect(find.text('Home'), findsOneWidget);

      await tester.tap(find.byType(Scaffold));
      await tester.pumpAndSettle();

      // Navigate to second route
      final BuildContext context = tester.element(find.text('Home'));
      Navigator.pushNamed(context, '/second');
      await tester.pumpAndSettle();

      expect(find.text('Second'), findsOneWidget);
    });

    testWidgets('should maintain theme during navigation',
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
    });
  });

  group('ThemedApp - Localization', () {
    testWidgets('should support locales', (WidgetTester tester) async {
      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          locale: Locale('es', 'ES'),
          supportedLocales: [
            Locale('en', 'US'),
            Locale('es', 'ES'),
          ],
          home: Scaffold(body: Text('Content')),
        ),
      );

      final MaterialApp app = tester.widget(find.byType(MaterialApp));
      expect(app.locale, Locale('es', 'ES'));
      expect(app.supportedLocales, contains(Locale('es', 'ES')));
    });
  });

  group('ThemedApp - ValueListenableBuilder', () {
    testWidgets('should use ValueListenableBuilder correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          home: Scaffold(body: Text('Content')),
        ),
      );

      expect(find.byType(ValueListenableBuilder<ThemeData>), findsOneWidget);
    });

    testWidgets('should rebuild only when theme changes',
        (WidgetTester tester) async {
      int buildCount = 0;

      await tester.pumpWidget(
        ThemedApp(
          title: 'Test App',
          home: Builder(
            builder: (context) {
              buildCount++;
              return Scaffold(
                body: Text('Build count: $buildCount'),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();
      final initialBuildCount = buildCount;

      // Pump without changing theme should not rebuild
      await tester.pump();
      expect(buildCount, initialBuildCount);

      // Changing theme should rebuild
      ThemeManager.setTheme('dark');
      await tester.pumpAndSettle();
      expect(buildCount, greaterThan(initialBuildCount));
    });
  });

  group('ThemedApp - Complete integration', () {
    testWidgets('should work in a complete real scenario',
        (WidgetTester tester) async {
      // Create custom theme
      ThemeManager.createTheme(
        name: 'ocean',
        primaryColor: Colors.blue,
        secondaryColor: Colors.teal,
        brightness: Brightness.light,
        borderRadius: 16.0,
      );

      await tester.pumpWidget(
        ThemedApp(
          title: 'Ocean App',
          home: Builder(
            builder: (context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Home'),
                  actions: [
                    IconButton(
                      icon: Icon(Icons.brightness_6),
                      onPressed: () {
                        ThemeManager.toggleTheme();
                      },
                    ),
                  ],
                ),
                body: Column(
                  children: [
                    Text('Welcome'),
                    ElevatedButton(
                      onPressed: () {
                        ThemeManager.setTheme('ocean');
                      },
                      child: Text('Ocean Theme'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify initial state
      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('Ocean Theme'), findsOneWidget);

      // Change to ocean theme
      await tester.tap(find.text('Ocean Theme'));
      await tester.pumpAndSettle();

      var context = tester.element(find.text('Welcome'));
      expect(Theme.of(context).colorScheme.primary, Colors.blue);

      // Toggle theme
      await tester.tap(find.byIcon(Icons.brightness_6));
      await tester.pumpAndSettle();

      context = tester.element(find.text('Welcome'));
      expect(Theme.of(context).brightness, Brightness.dark);
    });
  });
}

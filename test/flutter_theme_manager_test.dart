import 'package:flutter/material.dart'
    show
        Brightness,
        Colors,
        FontWeight,
        RoundedRectangleBorder,
        TextStyle,
        ThemeData;
import 'package:flutter_test/flutter_test.dart'
    show
        test,
        expect,
        group,
        setUp,
        contains,
        isTrue,
        isFalse,
        isA,
        throwsException;
import 'package:flutter_theme_manager/flutter_theme_manager.dart'
    show ThemeManager;

import 'test_utils.dart' show MockThemeStorageAdapter;

void main() {
  final mockStorage = MockThemeStorageAdapter();

  setUp(() async {
    await mockStorage.reset();
  });

  group('ThemeManager - Initialization', () {
    test('should have light and dark themes by default', () {
      expect(ThemeManager.hasTheme('light'), isTrue);
      expect(ThemeManager.hasTheme('dark'), isTrue);
    });

    test('should list all available themes', () {
      final themes = ThemeManager.availableThemes;
      expect(themes, contains('light'));
      expect(themes, contains('dark'));
    });

    test('should initialize with light theme by default', () async {
      await ThemeManager.initialize();
      expect(ThemeManager.currentTheme.brightness, Brightness.light);
    });

    test('should load last saved theme if it exists', () async {
      await mockStorage.saveTheme('dark');

      await ThemeManager.initialize(storageAdapter: mockStorage);

      expect(ThemeManager.currentTheme.brightness, Brightness.dark);
      expect(mockStorage.loadCallCount, 1);
    });

    test('should use light theme if saved theme does not exist', () async {
      await ThemeManager.initialize(storageAdapter: mockStorage);

      expect(ThemeManager.currentTheme, ThemeData.light());
    });
  });

  group('ThemeManager - Theme switching', () {
    setUp(() async {
      await ThemeManager.initialize(storageAdapter: mockStorage);
    });

    test('should switch theme correctly', () {
      ThemeManager.setTheme('dark');
      expect(ThemeManager.currentTheme.brightness, Brightness.dark);
    });

    test('should persist theme when switching', () async {
      ThemeManager.setTheme('dark');

      // Give time for async operation to complete
      await Future.delayed(Duration(milliseconds: 100));

      expect(mockStorage.savedTheme, 'dark');
      expect(mockStorage.saveCallCount, 1);
    });

    test('should do nothing if theme does not exist', () {
      final initialBrightness = ThemeManager.currentTheme.brightness;
      ThemeManager.setTheme('nonexistent');

      expect(ThemeManager.currentTheme.brightness, initialBrightness);
      expect(mockStorage.saveCallCount, 0);
    });

    test('should toggle between light and dark', () {
      // Starts with light
      ThemeManager.setTheme('light');
      expect(ThemeManager.currentTheme, ThemeData.light());

      ThemeManager.toggleTheme();
      expect(ThemeManager.currentTheme, ThemeData.dark());

      ThemeManager.toggleTheme();
      expect(ThemeManager.currentTheme, ThemeData.light());
    });
  });

  group('ThemeManager - Notifications', () {
    test('should notify theme changes', () async {
      await ThemeManager.initialize();

      var notificationCount = 0;
      ThemeManager.instance.themeNotifier.addListener(() {
        notificationCount++;
      });

      ThemeManager.setTheme('dark');
      await Future.delayed(Duration(milliseconds: 50));

      expect(notificationCount, 1);

      ThemeManager.setTheme('light');
      await Future.delayed(Duration(milliseconds: 50));

      expect(notificationCount, 2);
    });
  });

  group('ThemeManager - Custom themes', () {
    test('should create a custom theme', () {
      ThemeManager.createTheme(
        name: 'custom',
        primaryColor: Colors.purple,
        secondaryColor: Colors.amber,
        brightness: Brightness.light,
      );

      expect(ThemeManager.hasTheme('custom'), isTrue);
      expect(ThemeManager.availableThemes, contains('custom'));
    });

    test('should apply custom colors correctly', () {
      ThemeManager.createTheme(
        name: 'custom',
        primaryColor: Colors.purple,
        secondaryColor: Colors.amber,
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.grey[100],
      );

      ThemeManager.setTheme('custom');
      final theme = ThemeManager.currentTheme;

      expect(theme.colorScheme.primary, Colors.purple);
      expect(theme.colorScheme.secondary, Colors.amber);
      expect(theme.scaffoldBackgroundColor, Colors.grey[100]);
    });

    test('should apply Material3 configuration', () {
      ThemeManager.createTheme(
        name: 'material3',
        primaryColor: Colors.blue,
        secondaryColor: Colors.orange,
        brightness: Brightness.light,
        useMaterial3: true,
      );

      ThemeManager.setTheme('material3');
      expect(ThemeManager.currentTheme.useMaterial3, true);
    });

    test('should apply custom border radius', () {
      ThemeManager.createTheme(
        name: 'rounded',
        primaryColor: Colors.blue,
        secondaryColor: Colors.orange,
        brightness: Brightness.light,
        borderRadius: 20.0,
      );

      ThemeManager.setTheme('rounded');
      final theme = ThemeManager.currentTheme;
      final buttonShape = theme.elevatedButtonTheme.style?.shape?.resolve({});

      expect(buttonShape, isA<RoundedRectangleBorder>());
    });

    test('should remove custom theme', () {
      ThemeManager.createTheme(
        name: 'custom',
        primaryColor: Colors.purple,
        secondaryColor: Colors.amber,
        brightness: Brightness.light,
      );

      expect(ThemeManager.hasTheme('custom'), isTrue);

      ThemeManager.removeTheme('custom');
      expect(ThemeManager.hasTheme('custom'), isFalse);
    });

    test('should not allow removing default themes', () {
      expect(
        () => ThemeManager.removeTheme('light'),
        throwsException,
      );

      expect(
        () => ThemeManager.removeTheme('dark'),
        throwsException,
      );
    });

    test('should clear only custom themes', () {
      ThemeManager.createTheme(
        name: 'custom1',
        primaryColor: Colors.purple,
        secondaryColor: Colors.amber,
        brightness: Brightness.light,
      );

      ThemeManager.createTheme(
        name: 'custom2',
        primaryColor: Colors.green,
        secondaryColor: Colors.red,
        brightness: Brightness.dark,
      );

      ThemeManager.clearCustomThemes();

      expect(ThemeManager.hasTheme('light'), isTrue);
      expect(ThemeManager.hasTheme('dark'), isTrue);
      expect(ThemeManager.hasTheme('custom1'), isFalse);
      expect(ThemeManager.hasTheme('custom2'), isFalse);
    });
  });

  group('ThemeManager - Text styles and fonts', () {
    test('should apply custom font', () {
      ThemeManager.createTheme(
        name: 'custom-font',
        primaryColor: Colors.blue,
        secondaryColor: Colors.orange,
        brightness: Brightness.light,
        fontFamily: 'Roboto',
        fontWeight: FontWeight.bold,
      );

      ThemeManager.setTheme('custom-font');
      final textStyle = ThemeManager
          .currentTheme.textButtonTheme.style?.textStyle
          ?.resolve({});

      expect(textStyle?.fontFamily, 'Roboto');
      expect(textStyle?.fontWeight, FontWeight.bold);
    });

    test('should apply custom text styles', () {
      final headlineStyle =
          TextStyle(fontSize: 32, fontWeight: FontWeight.bold);
      final bodyStyle = TextStyle(fontSize: 16);

      ThemeManager.createTheme(
        name: 'custom-text',
        primaryColor: Colors.blue,
        secondaryColor: Colors.orange,
        brightness: Brightness.light,
        headlineStyle: headlineStyle,
        bodyStyle: bodyStyle,
      );

      ThemeManager.setTheme('custom-text');
      final theme = ThemeManager.currentTheme;

      expect(theme.textTheme.headlineLarge?.fontSize, 32);
      expect(theme.textTheme.bodyLarge?.fontSize, 16);
    });
  });

  group('ThemeManager - Edge cases', () {
    test('should handle multiple initializations', () async {
      await ThemeManager.initialize();
      await ThemeManager.initialize(); // Should not cause issues

      expect(ThemeManager.hasTheme('light'), isTrue);
    });

    test('should work without storage adapter', () async {
      await ThemeManager.initialize();
      ThemeManager.setTheme('dark');

      // Should not throw error
      expect(ThemeManager.currentTheme, ThemeData.dark());
    });
  });
}

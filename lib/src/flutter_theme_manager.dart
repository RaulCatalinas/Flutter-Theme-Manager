import 'package:flutter/material.dart'
    show Brightness, ThemeData, ValueNotifier;

class ThemeManager {
  static final ThemeManager instance = ThemeManager._internal();
  late ValueNotifier<ThemeData> themeNotifier;
  final Map<String, ThemeData> _themes = {};

  factory ThemeManager() => instance;

  static List<String> get availableThemes => instance._themes.keys.toList();

  ThemeManager._internal() {
    instance._themes['light'] = ThemeData.light();
    instance._themes['dark'] = ThemeData.dark();

    instance.themeNotifier = ValueNotifier(instance._themes['light']!);
  }

  static void setTheme(String name) {
    final theme = instance._themes[name];

    if (theme != null) {
      instance.themeNotifier.value = theme;
    }
  }

  static void toggleTheme() {
    final isLight = instance.themeNotifier.value.brightness == Brightness.light;
    instance.themeNotifier.value = isLight
        ? instance._themes['dark']!
        : instance._themes['light']!;
  }
}

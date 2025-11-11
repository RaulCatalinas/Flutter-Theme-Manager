import 'package:flutter/material.dart'
    show
        AppBarTheme,
        BorderRadius,
        BorderSide,
        Brightness,
        CardThemeData,
        Color,
        ColorScheme,
        Colors,
        ElevatedButton,
        ElevatedButtonThemeData,
        FloatingActionButtonThemeData,
        FontWeight,
        IconThemeData,
        InkRipple,
        InputDecorationTheme,
        NoSplash,
        OutlineInputBorder,
        OutlinedButton,
        OutlinedButtonThemeData,
        RoundedRectangleBorder,
        TextButton,
        TextButtonThemeData,
        TextStyle,
        TextTheme,
        ThemeData,
        ValueNotifier;

abstract class ThemeStorageAdapter {
  Future<void> saveTheme(String themeName);
  Future<String?> loadTheme();
}

class ThemeManager {
  static final ThemeManager _instance = ThemeManager._internal();
  late ValueNotifier<ThemeData> themeNotifier;
  final Map<String, ThemeData> _themes = {};
  String _currentThemeName = 'light';
  ThemeStorageAdapter? _storageAdapter;

  static ThemeManager get instance => _instance;
  static ThemeData get currentTheme => _instance.themeNotifier.value;
  static String get currentThemeName => _instance._currentThemeName;
  static List<String> get availableThemes => _instance._themes.keys.toList();
  static bool hasTheme(String name) => _instance._themes.containsKey(name);

  factory ThemeManager() => _instance;

  ThemeManager._internal() {
    _themes['light'] = ThemeData.light();
    _themes['dark'] = ThemeData.dark();
    themeNotifier = ValueNotifier(_themes['light']!);
  }

  static Future<void> initialize({ThemeStorageAdapter? storageAdapter}) async {
    _instance._storageAdapter = storageAdapter;

    _instance._themes['light'] = ThemeData.light();
    _instance._themes['dark'] = ThemeData.dark();

    String? lastTheme;

    if (storageAdapter != null) {
      lastTheme = await storageAdapter.loadTheme();
    }

    final theme = _instance._themes[lastTheme] ?? _instance._themes['light']!;
    _instance.themeNotifier.value = theme;
    _instance._currentThemeName = lastTheme ?? 'light';
  }

  static void setTheme(String name) async {
    final theme = _instance._themes[name];

    if (theme == null) return;

    _instance.themeNotifier.value = theme;
    _instance._currentThemeName = name;

    if (_instance._storageAdapter != null) {
      await _instance._storageAdapter!.saveTheme(name);
    }
  }

  static void toggleTheme() async {
    final isLight =
        _instance.themeNotifier.value.brightness == Brightness.light;

    final newTheme = isLight ? 'dark' : 'light';

    setTheme(newTheme);
  }

  static void removeTheme(String name) {
    if (name == 'light' || name == 'dark') {
      throw Exception('Cannot remove default themes');
    }

    _instance._themes.remove(name);
  }

  static void clearCustomThemes() {
    _instance._themes.removeWhere((key, _) => key != 'light' && key != 'dark');
  }

  static void createTheme({
    required String name,
    required Color primaryColor,
    required Color secondaryColor,
    required Brightness brightness,
    Color? backgroundColor,
    Color? surfaceColor,
    Color? scaffoldBackgroundColor,
    Color? appBarColor,
    Color? cardColor,
    Color? dividerColor,
    Color? iconColor,
    Color? textColor,
    Color? hintColor,
    Color? disabledColor,
    Color? errorColor,
    Color? buttonColor,
    double? borderRadius,
    double? elevation,
    Color? fabColor,
    Color? inputFillColor,
    Color? inputBorderColor,
    String? fontFamily,
    FontWeight? fontWeight,
    TextStyle? headlineStyle,
    TextStyle? bodyStyle,
    TextStyle? buttonTextStyle,
    bool? useMaterial3,
    bool? useRippleEffect,
  }) {
    final isLight = brightness == Brightness.light;

    final theme = ThemeData(
      useMaterial3: useMaterial3,
      brightness: brightness,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: scaffoldBackgroundColor,
      cardColor: cardColor,
      dividerColor: dividerColor,
      disabledColor: disabledColor,
      hintColor: hintColor,
      iconTheme: IconThemeData(color: iconColor),
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: primaryColor,
        onPrimary: textColor ?? Colors.white,
        secondary: secondaryColor,
        onSecondary: textColor ?? Colors.white,
        error: errorColor ?? Colors.red,
        onError: Colors.white,
        surface:
            surfaceColor ?? (isLight ? Colors.white : const Color(0xFF1E1E1E)),
        onSurface: textColor ?? (isLight ? Colors.black : Colors.white),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: appBarColor,
        foregroundColor: textColor,
        elevation: elevation,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: fabColor,
        foregroundColor: textColor,
        elevation: elevation,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: textColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
          elevation: elevation,
          textStyle: buttonTextStyle,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: secondaryColor,
          textStyle: TextStyle(fontWeight: fontWeight, fontFamily: fontFamily),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: secondaryColor,
          side: BorderSide(color: secondaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: inputFillColor,
        hintStyle: TextStyle(color: hintColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(color: inputBorderColor ?? Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(color: inputBorderColor ?? Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
      ),
      cardTheme: CardThemeData(
        color: cardColor,
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 12),
        ),
      ),
      textTheme: TextTheme(headlineLarge: headlineStyle, bodyLarge: bodyStyle),
      splashFactory: (useRippleEffect ?? true)
          ? InkRipple.splashFactory
          : NoSplash.splashFactory,
    );

    _instance._themes[name] = theme;
  }
}

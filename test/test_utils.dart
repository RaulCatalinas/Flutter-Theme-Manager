import 'package:flutter_theme_manager/flutter_theme_manager.dart'
    show ThemeStorageAdapter;

class MockThemeStorageAdapter implements ThemeStorageAdapter {
  String? savedTheme;
  String? themeToLoad;
  int saveCallCount = 0;
  int loadCallCount = 0;

  @override
  Future<void> saveTheme(String themeName) async {
    savedTheme = themeName;
    saveCallCount++;
  }

  @override
  Future<String?> loadTheme() async {
    loadCallCount++;
    return themeToLoad;
  }

  void reset() {
    savedTheme = null;
    themeToLoad = null;
    saveCallCount = 0;
    loadCallCount = 0;
  }
}

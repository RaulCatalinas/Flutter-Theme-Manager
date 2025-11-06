import 'dart:convert';
import 'dart:io' show File;

import 'package:flutter_theme_manager/flutter_theme_manager.dart'
    show ThemeStorageAdapter;

class MockThemeStorageAdapter implements ThemeStorageAdapter {
  int saveCallCount = 0;
  int loadCallCount = 0;
  String? savedTheme;

  // File used to simulate persistence during tests
  File testFile = File('mock_theme_storage.json');

  @override
  Future<void> saveTheme(String themeName) async {
    final json = jsonEncode({'theme': themeName});
    testFile.writeAsStringSync(json, flush: true);

    saveCallCount++;
  }

  @override
  Future<String?> loadTheme() async {
    if (!testFile.existsSync()) return null;

    final content = testFile.readAsStringSync();
    final data = jsonDecode(content);

    savedTheme = data['theme'];

    loadCallCount++;

    return savedTheme;
  }

  Future<void> reset() async {
    saveCallCount = 0;
    loadCallCount = 0;
    if (await testFile.exists()) {
      await testFile.delete();
    }
  }
}

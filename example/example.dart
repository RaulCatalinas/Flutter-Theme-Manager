import 'package:flutter/material.dart';
import 'package:flutter_theme_manager/flutter_theme_manager.dart';
import 'package:flutter_theme_manager/themed_app.dart';

// ============================================================================
// STORAGE ADAPTER (Optional - use your preferred storage)
// ============================================================================

/// Implement ThemeStorageAdapter with your preferred storage solution:
/// - SharedPreferences: await prefs.setString('theme', themeName)
/// - Hive: await box.put('theme', themeName)
/// - GetStorage: await storage.write('theme', themeName)
/// - Or any other storage you prefer
class MyThemeStorage implements ThemeStorageAdapter {
  String? _savedTheme;

  @override
  Future<void> saveTheme(String themeName) async {
    _savedTheme = themeName;
    // Replace with your storage logic
  }

  @override
  Future<String?> loadTheme() async {
    return _savedTheme;
    // Replace with your storage logic
  }
}

void main() async {
  // Only necessary if you use native plugins:
  WidgetsFlutterBinding.ensureInitialized();

  await ThemeManager.initialize(
    storageAdapter:
        MyThemeStorage(), // Remove the storageAdapter parameter if you don't need persistence.
  );

  ThemeManager.createTheme(
    name: 'ocean',
    primaryColor: const Color(0xFF006994),
    secondaryColor: const Color(0xFF4A90A4),
    brightness: Brightness.light,
    borderRadius: 16,
  );

  ThemeManager.createTheme(
    name: 'sunset',
    primaryColor: Colors.deepOrange,
    secondaryColor: Colors.amber,
    brightness: Brightness.light,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      title: 'Theme Manager Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Manager'),
        actions: [
          IconButton(
            icon: Icon(
              ThemeManager.currentTheme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: () => ThemeManager.toggleTheme(),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Icon(
                    Icons.palette,
                    size: 64,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    ThemeManager.currentThemeName.toUpperCase(),
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Available Themes',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          ...ThemeManager.availableThemes.map((theme) {
            final isCurrent = ThemeManager.currentThemeName == theme;
            return Card(
              child: ListTile(
                leading: Icon(
                  _getIcon(theme),
                  color: isCurrent ? Theme.of(context).primaryColor : null,
                ),
                title: Text(theme),
                trailing: isCurrent ? const Icon(Icons.check_circle) : null,
                onTap: () => ThemeManager.setTheme(theme),
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getIcon(String theme) {
    switch (theme.toLowerCase()) {
      case 'light':
        return Icons.wb_sunny;
      case 'dark':
        return Icons.nightlight_round;
      case 'ocean':
        return Icons.water;
      case 'sunset':
        return Icons.wb_twilight;
      default:
        return Icons.palette;
    }
  }
}

# Flutter Theme Manager

A simple, plug-and-play theme management library for Flutter with automatic persistence and zero configuration required.

## Features

✨ **Zero Configuration** - Works out of the box with light and dark themes  
🔄 **Automatic Persistence** - Saves user theme preference automatically  
🎨 **Unlimited Custom Themes** - Create as many themes as you need with a simple API  
🚀 **Drop-in Replacement** - Just replace `MaterialApp` with `ThemedApp`
⚡ **Hot Reload Friendly** - See theme changes instantly during development

## Getting Started

### Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_theme_manager: ^1.0.0
```

Then run:

```bash
flutter pub get
```

### Basic Usage

```dart
import 'package:flutter/material.dart';
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
  await ThemeManager.initialize(
    storageAdapter:
        MyThemeStorage(), // Remove the storageAdapter parameter if you don't need persistence.
  );


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      title: 'My App',
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
        title: const Text('Theme Manager Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () => ThemeManager.toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Text('Current theme: ${ThemeManager.currentThemeName}'),
      ),
    );
  }
}
```

That's it! Your app now has automatic theme switching with persistent preferences.

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_theme_manager/flutter_theme_manager.dart';

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
  await ThemeManager.initialize(
    storageAdapter:
        MyThemeStorage(), // Remove the storageAdapter parameter if you don't need persistence.
  );

  // Create custom themes before running the app
  ThemeManager.createTheme(
    name: 'ocean',
    primaryColor: Colors.blue[800]!,
    secondaryColor: Colors.lightBlue,
    brightness: Brightness.light,
  );

  ThemeManager.createTheme(
    name: 'forest',
    primaryColor: Colors.green[700]!,
    secondaryColor: Colors.lightGreen,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A2F1A),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      title: 'Theme Gallery',
      home: const ThemeSelector(),
    );
  }
}

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Theme')),
      body: ListView.builder(
        itemCount: ThemeManager.availableThemes.length,
        itemBuilder: (context, index) {
          final themeName = ThemeManager.availableThemes[index];
          final isSelected = ThemeManager.currentThemeName == themeName;

          return ListTile(
            title: Text(themeName),
            trailing: isSelected ? const Icon(Icons.check) : null,
            selected: isSelected,
            onTap: () => ThemeManager.setTheme(themeName),
          );
        },
      ),
    );
  }
}
```

## Additional Examples

### 🔹 Minimal Setup Example

The simplest possible implementation - just replace MaterialApp:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_theme_manager/flutter_theme_manager.dart';

void main() async {
  await ThemeManager.initialize();

  runApp(const MyApp())
};

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Minimal Example'),
          actions: [
            IconButton(
              icon: const Icon(Icons.palette),
              onPressed: () => ThemeManager.toggleTheme(),
            ),
          ],
        ),
        body: const Center(child: Text('Hello, World!')),
      ),
    );
  }
}
```

### 🔹 Custom Themes Example

Create multiple themed experiences for your app:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_theme_manager/flutter_theme_manager.dart';

void main() async {
  await ThemeManager.initialize();

  // 🌊 Ocean theme
  ThemeManager.createTheme(
    name: 'ocean',
    primaryColor: const Color(0xFF006994),
    secondaryColor: const Color(0xFF4A90A4),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF0F8FF),
  );

  // 🌲 Forest theme
  ThemeManager.createTheme(
    name: 'forest',
    primaryColor: const Color(0xFF2E7D32),
    secondaryColor: const Color(0xFF66BB6A),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1A2F1A),
    cardColor: const Color(0xFF263D26),
  );

  // 🌸 Rose theme
  ThemeManager.createTheme(
    name: 'rose',
    primaryColor: Colors.pink[400]!,
    secondaryColor: Colors.pinkAccent,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.pink[50],
    borderRadius: 20,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      title: 'Custom Themes Demo',
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Theme Gallery')),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: ThemeManager.availableThemes.length,
        itemBuilder: (context, index) {
          final theme = ThemeManager.availableThemes[index];
          final isCurrent = ThemeManager.currentThemeName == theme;

          return ElevatedButton(
            onPressed: () => ThemeManager.setTheme(theme),
            style: ElevatedButton.styleFrom(
              backgroundColor: isCurrent ? Theme.of(context).primaryColor : null,
            ),
            child: Text(theme),
          );
        },
      ),
    );
  }
}
```

### 🔹 Advanced Configuration Example

Full customization with typography, colors, and component styles:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_theme_manager/flutter_theme_manager.dart';

void main() async {
  await ThemeManager.initialize();

  ThemeManager.createTheme(
    name: 'professional',
    
    // Main colors
    primaryColor: const Color(0xFF2C3E50),
    secondaryColor: const Color(0xFF3498DB),
    brightness: Brightness.light,
    
    // Background colors
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    cardColor: Colors.white,
    
    // Component styling
    borderRadius: 16,
    elevation: 4,
    
    // AppBar customization
    appBarColor: const Color(0xFF2C3E50),
    
    // Button colors
    buttonColor: const Color(0xFF3498DB),
    fabColor: const Color(0xFF3498DB),
    
    // Input fields
    inputFillColor: Colors.white,
    inputBorderColor: const Color(0xFFE0E0E0),
    
    // Typography
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    
    // Effects
    useMaterial3: true,
    useRippleEffect: true,
  );

  runApp(const MyApp());
}
```

## Creating Custom Themes

ThemeManager provides a simple API to create custom themes. Only three parameters are required:

```dart
ThemeManager.createTheme(
  name: 'my_theme',              // Required: unique identifier
  primaryColor: Colors.blue,      // Required: main app color
  secondaryColor: Colors.blueAccent, // Required: accent color
  brightness: Brightness.light,   // Required: light or dark
  // ... all other parameters are optional
);
```

## API Reference

### ThemedApp Widget

`ThemedApp` is a drop-in replacement for `MaterialApp` that automatically handles theme changes. It accepts all the same parameters as `MaterialApp`:

```dart
ThemedApp(
  title: 'My App',
  home: HomePage(),
  routes: {...},
  theme: ..., // Don't use this - ThemeManager handles it
  darkTheme: ..., // Don't use this - ThemeManager handles it
  // ... all other MaterialApp parameters work normally
)
```

**Note:** Do not set `theme` or `darkTheme` parameters manually as ThemeManager controls these automatically.

## Best Practices

### Create Themes Before runApp

Define all your custom themes in `main()` before calling `runApp()`:

```dart
void main() {
  // Create themes first
  ThemeManager.createTheme(
    name: 'custom',
    primaryColor: Colors.purple,
    secondaryColor: Colors.purpleAccent,
    brightness: Brightness.dark,
  );
  
  // Then run app
  runApp(const MyApp());
}
```

### Use Descriptive Theme Names

Choose clear, meaningful names for your themes:

```dart
// ❌ Bad
ThemeManager.createTheme(name: 'theme1', ...);

// ✅ Good
ThemeManager.createTheme(name: 'ocean_breeze', ...);
```

### Provide Visual Feedback

Show users which theme is currently active:

```dart
ListTile(
  title: Text(themeName),
  trailing: ThemeManager.currentThemeName == themeName 
    ? const Icon(Icons.check) 
    : null,
  onTap: () => ThemeManager.setTheme(themeName),
)
```

### Handle Theme Changes Gracefully

Theme changes are automatic, but you can react to them if needed:

```dart
// Access theme anywhere in your widget tree
final isDark = ThemeManager.currentTheme.brightness == Brightness.dark;

// Or use Theme.of(context) as usual
final primaryColor = Theme.of(context).primaryColor;
```

## FAQ

### How does persistence work?

Flutter Theme Manager automatically saves the selected theme using SharedPreferences. When your app restarts, it loads the last selected theme automatically.

### Can I use it without SharedPreferences?

Yes! If SharedPreferences is not available, the library will still work but won't persist theme choices between app restarts.

### Does it work with MaterialApp.router?

Currently, Flutter Theme Manager only supports the standard `MaterialApp`. Support for `MaterialApp.router` may be added in a future version.

### Can I change themes programmatically?

Absolutely! Use `ThemeManager.setTheme('themeName')` from anywhere in your code - no BuildContext required.

### What happens to my custom themes on hot reload?

Custom themes persist during hot reload, so you can see your changes immediately without losing your theme configuration.

### Can I override the default light/dark themes?

The default 'light' and 'dark' themes cannot be removed, but you can create themes with the same names to replace them.

## Roadmap

Future features under consideration:

- 🔄 Theme transitions/animations
- 📱 System theme detection
- 🎨 Theme presets library
- 🌙 Automatic dark mode scheduling
- 💾 Custom storage adapters
- 🎯 Theme inheritance

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

If you encounter any issues or have questions, please [open an issue](hhttps://github.com/RaulCatalinas/Flutter-Theme-Manager/issues) on GitHub.

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a list of changes in each version.

import 'package:flutter/material.dart';
import 'package:flutter_theme_manager/flutter_theme_manager.dart';

/// Basic Example - The simplest possible implementation
///
/// This example shows how to use Flutter Theme Manager with zero configuration.
/// Just replace MaterialApp with ThemedApp and you're done!
void main() {
  runApp(const BasicExample());
}

class BasicExample extends StatelessWidget {
  const BasicExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(title: 'Basic Example', home: const HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Basic Theme Manager'),
        actions: [
          // Simple toggle button for light/dark themes
          IconButton(
            icon: Icon(
              ThemeManager.currentTheme.brightness == Brightness.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            tooltip: 'Toggle theme',
            onPressed: () => ThemeManager.toggleTheme(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.palette,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            Text(
              'Current Theme',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              ThemeManager.currentThemeName,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => ThemeManager.toggleTheme(),
              icon: const Icon(Icons.swap_horiz),
              label: const Text('Toggle Theme'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Theme: ${ThemeManager.currentThemeName}'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: const Icon(Icons.info),
      ),
    );
  }
}

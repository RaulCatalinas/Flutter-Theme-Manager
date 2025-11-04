import 'package:flutter/material.dart';
import 'package:flutter_theme_manager/flutter_theme_manager.dart';
import 'package:flutter_theme_manager/themed_app.dart';

/// Advanced Example
///
/// This example demonstrates advanced theme customization including:
/// - Custom typography
/// - Component-specific styling
/// - Input decorations
/// - Custom border radius and elevations
/// - Integration with app settings
void main() {
  _createAdvancedThemes();
  runApp(const AdvancedExample());
}

void _createAdvancedThemes() {
  // Professional Business Theme
  ThemeManager.createTheme(
    name: 'professional',
    primaryColor: const Color(0xFF2C3E50),
    secondaryColor: const Color(0xFF3498DB),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
    cardColor: Colors.white,
    appBarColor: const Color(0xFF2C3E50),
    buttonColor: const Color(0xFF3498DB),
    fabColor: const Color(0xFF3498DB),
    borderRadius: 16,
    elevation: 4,
    inputFillColor: Colors.white,
    inputBorderColor: const Color(0xFFE0E0E0),
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
    useMaterial3: true,
    useRippleEffect: true,
  );

  // Neon Dark Theme
  ThemeManager.createTheme(
    name: 'neon',
    primaryColor: const Color(0xFF00FFF0),
    secondaryColor: const Color(0xFFFF00FF),
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF0A0A0A),
    cardColor: const Color(0xFF1A1A1A),
    textColor: const Color(0xFF00FFF0),
    iconColor: const Color(0xFF00FFF0),
    borderRadius: 8,
    elevation: 8,
    useRippleEffect: true,
  );

  // Soft Pastel Theme
  ThemeManager.createTheme(
    name: 'pastel',
    primaryColor: const Color(0xFF9B59B6),
    secondaryColor: const Color(0xFF3498DB),
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFFF5F7),
    cardColor: Colors.white,
    appBarColor: const Color(0xFF9B59B6),
    buttonColor: const Color(0xFF9B59B6),
    borderRadius: 24,
    elevation: 2,
    inputFillColor: const Color(0xFFFFF0F5),
    inputBorderColor: const Color(0xFFE1BEE7),
    useMaterial3: true,
  );

  // High Contrast Theme (Accessibility)
  ThemeManager.createTheme(
    name: 'high_contrast',
    primaryColor: Colors.black,
    secondaryColor: Colors.yellow[700]!,
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    cardColor: Colors.grey[100]!,
    textColor: Colors.black,
    iconColor: Colors.black,
    borderRadius: 4,
    elevation: 0,
    buttonColor: Colors.black,
    fabColor: Colors.yellow[700]!,
    inputBorderColor: Colors.black,
    fontWeight: FontWeight.w600,
    useRippleEffect: false,
  );
}

class AdvancedExample extends StatelessWidget {
  const AdvancedExample({super.key});

  @override
  Widget build(BuildContext context) {
    return ThemedApp(
      title: 'Advanced Example',
      home: const MainPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    HomePage(),
    ComponentsPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Theme Demo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => _showThemeInfo(context),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.widgets_outlined),
            selectedIcon: Icon(Icons.widgets),
            label: 'Components',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _showThemeInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Current Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow('Name', ThemeManager.currentThemeName),
            _InfoRow(
              'Brightness',
              ThemeManager.currentTheme.brightness == Brightness.light
                  ? 'Light'
                  : 'Dark',
            ),
            _InfoRow(
              'Total Themes',
              ThemeManager.availableThemes.length.toString(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$label:', style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
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
                const SizedBox(height: 8),
                Text(
                  'Advanced theme customization demo',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        _FeatureCard(
          icon: Icons.color_lens,
          title: 'Custom Colors',
          description: 'Fully customizable color schemes',
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.text_fields,
          title: 'Typography',
          description: 'Custom fonts and text styles',
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.widgets,
          title: 'Component Styles',
          description: 'Customized buttons, cards, and inputs',
        ),
        const SizedBox(height: 12),
        _FeatureCard(
          icon: Icons.save,
          title: 'Auto Persistence',
          description: 'Theme preference saved automatically',
        ),
      ],
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Theme.of(context).primaryColor),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(description),
      ),
    );
  }
}

class ComponentsPage extends StatelessWidget {
  const ComponentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Buttons', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            ElevatedButton(onPressed: () {}, child: const Text('Elevated')),
            OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
            TextButton(onPressed: () {}, child: const Text('Text')),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.send),
              label: const Text('With Icon'),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text('Input Fields', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Username',
            hintText: 'Enter your username',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Email',
            hintText: 'Enter your email',
            prefixIcon: Icon(Icons.email),
          ),
        ),
        const SizedBox(height: 12),
        const TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Enter your password',
            prefixIcon: Icon(Icons.lock),
            suffixIcon: Icon(Icons.visibility),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 24),
        Text('Cards', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sample Card',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  'This card demonstrates the custom styling applied to card components.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const Icon(Icons.notification_important),
            title: const Text('Notification'),
            subtitle: const Text('You have 3 new messages'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ),
        const SizedBox(height: 24),
        Text('Chips', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.star, size: 18),
              label: const Text('Featured'),
            ),
            Chip(
              avatar: const Icon(Icons.new_releases, size: 18),
              label: const Text('New'),
            ),
            Chip(
              avatar: const Icon(Icons.trending_up, size: 18),
              label: const Text('Trending'),
            ),
          ],
        ),
      ],
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Theme Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.palette),
          title: const Text('Current Theme'),
          subtitle: Text(ThemeManager.currentThemeName),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _showThemeSelector(context),
        ),
        const Divider(),
        SwitchListTile(
          secondary: const Icon(Icons.dark_mode),
          title: const Text('Dark Mode'),
          subtitle: const Text('Toggle between light and dark'),
          value: ThemeManager.currentTheme.brightness == Brightness.dark,
          onChanged: (_) => ThemeManager.toggleTheme(),
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info),
          title: const Text('Available Themes'),
          subtitle: Text('${ThemeManager.availableThemes.length} themes'),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ThemeManager.availableThemes.take(4).map((theme) {
              final isCurrent = ThemeManager.currentThemeName == theme;
              return ChoiceChip(
                label: Text(theme),
                selected: isCurrent,
                onSelected: (selected) {
                  if (selected) {
                    ThemeManager.setTheme(theme);
                  }
                },
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showThemeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        shrinkWrap: true,
        itemCount: ThemeManager.availableThemes.length,
        itemBuilder: (context, index) {
          final theme = ThemeManager.availableThemes[index];
          final isCurrent = ThemeManager.currentThemeName == theme;

          return ListTile(
            leading: Icon(
              _getThemeIcon(theme),
              color: isCurrent ? Theme.of(context).primaryColor : null,
            ),
            title: Text(theme),
            trailing: isCurrent ? const Icon(Icons.check) : null,
            selected: isCurrent,
            onTap: () {
              ThemeManager.setTheme(theme);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }

  IconData _getThemeIcon(String theme) {
    switch (theme.toLowerCase()) {
      case 'light':
        return Icons.wb_sunny;
      case 'dark':
        return Icons.nightlight_round;
      case 'professional':
        return Icons.business;
      case 'neon':
        return Icons.flash_on;
      case 'pastel':
        return Icons.color_lens;
      case 'high_contrast':
        return Icons.contrast;
      default:
        return Icons.palette;
    }
  }
}

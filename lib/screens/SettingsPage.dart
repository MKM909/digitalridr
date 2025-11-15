import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/theme_manager.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final themeManager = Provider.of<ThemeManager>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Theme Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RadioListTile<ThemeMode?>(
              title: const Text('System Default'),
              value: null,
              groupValue: themeManager.isUserSelected
                  ? (themeManager.themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light)
                  : null,
              onChanged: (value) async {
                await themeManager.toggleTheme(null);
              },
            ),
            RadioListTile<ThemeMode?>(
              title: const Text('Light Mode'),
              value: ThemeMode.light,
              groupValue: themeManager.isUserSelected
                  ? (themeManager.themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light)
                  : null,
              onChanged: (value) async {
                await themeManager.toggleTheme(false);
              },
            ),
            RadioListTile<ThemeMode?>(
              title: const Text('Dark Mode'),
              value: ThemeMode.dark,
              groupValue: themeManager.isUserSelected
                  ? (themeManager.themeMode == ThemeMode.dark ? ThemeMode.dark : ThemeMode.light)
                  : null,
              onChanged: (value) async {
                await themeManager.toggleTheme(true);
              },
            ),
          ],
        ),
      ),
    );
  }
}
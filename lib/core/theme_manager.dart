import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isDisposed = false;
  bool _isUserSelected = false; // Track if user has explicitly selected a theme

  ThemeMode get themeMode => _themeMode;
  bool get isUserSelected => _isUserSelected;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    // Only use saved preference if user has previously selected a theme
    if (prefs.containsKey('isDark')) {
      _isUserSelected = true;
      _themeMode = prefs.getBool('isDark') == true ? ThemeMode.dark : ThemeMode.light;
    } else {
      // Default to system theme if no user preference exists
      _themeMode = ThemeMode.system;
    }
    _safeNotify();
  }

  Future<void> toggleTheme(bool? isDark) async {
    final prefs = await SharedPreferences.getInstance();
    if (isDark == null) {
      // User selected system theme
      _themeMode = ThemeMode.system;
      await prefs.remove('isDark');
      _isUserSelected = false;
    } else {
      // User selected light or dark explicitly
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
      await prefs.setBool('isDark', isDark);
      _isUserSelected = true;
    }
    _safeNotify();
  }

  void _safeNotify() {
    if (!_isDisposed) {
      notifyListeners();
    } else {
      debugPrint('Attempted to notify after dispose');
    }
  }
}
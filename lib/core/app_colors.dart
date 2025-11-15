import 'package:digitalridr/tools/hexToColor.dart';
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();
  static final instance = AppColors._();
  static BuildContext? _context;
  static void setContext(BuildContext context) => _context = context;
  // Material 3 Color Seeds (Light/Dark)
  static const Color seedColor = Colors.indigo;
  static final Color _txtColor = hexToColor('#333333');
  static const Color _bgColor = Colors.white;
  static final Color _iconColor = hexToColor('#222222');
  static final Color _unselectedIconColor = hexToColor('#F7931E');

  static const Color _darkTxtColor = Colors.white;
  static final Color _darkBgColor = hexToColor('#1E272C');
  static final Color _darkIconColor = hexToColor('#F7931E');
  static final Color _darkUnselectedIconColor = hexToColor('#E0E0E0');
  static const Color darkSeedColor = Colors.tealAccent;

  Color get textColor => _isDarkMode ? _darkTxtColor : _txtColor;
  Color get bgColor => _isDarkMode ? _darkBgColor : _bgColor;
  Color get iconColor => _isDarkMode ? _darkIconColor : _iconColor;
  Color get unselectedIconColor => _isDarkMode ? _darkUnselectedIconColor : _unselectedIconColor;
  // Generate Material 3 color schemes
  static ColorScheme lightScheme() {
    return ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.light,
    );
  }

  static ColorScheme darkScheme() {
    return ColorScheme.fromSeed(
      seedColor: darkSeedColor,
      brightness: Brightness.dark,
    );
  }

  // Get current scheme (light/dark)
  static ColorScheme of(BuildContext context) {
    return Theme.of(context).colorScheme;
  }
  bool get _isDarkMode => Theme.of(_context!).brightness == Brightness.dark;

}
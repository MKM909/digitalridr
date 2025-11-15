import 'package:flutter/material.dart';

class AppGradients {
  // Light/Dark variants for all gradients
  static LinearGradient get primaryGradient {
    return _isDarkMode
        ? const LinearGradient(colors: [
      Colors.indigoAccent,
      Colors.tealAccent,],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,)
        : const LinearGradient(colors: [
      Colors.indigo,
      Colors.teal,],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,);
  }

  static LinearGradient get loginSignupGradient {
    return _isDarkMode
        ? LinearGradient(colors: [
      Colors.indigo.shade300,
      Colors.teal.shade300,],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,)
        : LinearGradient(colors: [
      Colors.indigo.shade50,
      Colors.teal.shade50,],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,);
  }

  static LinearGradient get frostedBottomNavGradient {
    return _isDarkMode
        ? LinearGradient(colors: [
      Colors.indigo.shade200,
      Colors.teal.shade200,],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,)
        : LinearGradient(colors: [
      Colors.teal.shade200,
      Colors.indigo.shade200,],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,);
  }

  // Helper to check theme
  static bool get _isDarkMode => Theme.of(_context!).brightness == Brightness.dark;
  static BuildContext? _context;
  static void setContext(BuildContext context) => _context = context;
}
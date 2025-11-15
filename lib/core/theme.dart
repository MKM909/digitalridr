import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_gradients.dart';

ThemeData lightTheme() {
  final scheme = AppColors.lightScheme();
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    extensions: [
      _AppTheme(
        primaryGradient: AppGradients.primaryGradient,
      ),
    ],
  );
}

ThemeData darkTheme() {
  final scheme = AppColors.darkScheme();
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    extensions: [
      _AppTheme(
        primaryGradient: AppGradients.primaryGradient,
      ),
    ],
  );
}

// Custom theme extension for gradients
class _AppTheme extends ThemeExtension<_AppTheme> {
  final LinearGradient primaryGradient;

  const _AppTheme({required this.primaryGradient});

  @override
  ThemeExtension<_AppTheme> copyWith({LinearGradient? primaryGradient}) {
    return _AppTheme(
      primaryGradient: primaryGradient ?? this.primaryGradient,
    );
  }

  @override
  ThemeExtension<_AppTheme> lerp(ThemeExtension<_AppTheme>? other, double t) {
    return this;
  }
}
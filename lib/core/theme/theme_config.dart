import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

/// Defines the application's light and dark [ThemeData].
///
/// Both themes are derived from the shared [AppColors] palette so the brand
/// stays consistent across modes. Pass these into `GetMaterialApp` via the
/// `theme` and `darkTheme` parameters.
class ThemeConfig {
  ThemeConfig._(); // Prevent instantiation.

  /// Light theme used as the default brightness.
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.lightBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.light,
          surface: AppColors.lightSurface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
      );

  /// Dark theme counterpart.
  static ThemeData get dark => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.darkBackground,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          brightness: Brightness.dark,
          surface: AppColors.darkSurface,
          error: AppColors.error,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.darkSurface,
          foregroundColor: AppColors.darkText,
          elevation: 0,
          centerTitle: true,
        ),
      );
}

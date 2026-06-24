import 'package:flutter/material.dart';

/// Centralized color palette for the application.
///
/// Reference these constants from the theme configuration and from widgets
/// instead of hardcoding hex values inline. This keeps the design system in a
/// single, easy-to-audit place.
class AppColors {
  AppColors._(); // Prevent instantiation.

  // Brand.
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color accent = Color(0xFFFFA000);

  // Light theme surfaces.
  static const Color lightBackground = Color(0xFFF7F8FA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightText = Color(0xFF1A1A1A);

  // Dark theme surfaces.
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkText = Color(0xFFECECEC);

  // Semantic.
  static const Color error = Color(0xFFD32F2F);
  static const Color success = Color(0xFF2E7D32);
}

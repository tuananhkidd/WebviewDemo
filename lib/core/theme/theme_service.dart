import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Provides easy theme switching through GetX.
///
/// Usage from anywhere in the app:
/// ```dart
/// ThemeService.to.toggleTheme();      // switch light <-> dark
/// ThemeService.to.isDarkMode;         // read current mode
/// ```
class ThemeService extends GetxController {
  /// Convenience accessor for the registered singleton instance.
  static ThemeService get to => Get.find();

  /// Whether dark mode is currently active. Defaults to system brightness.
  final RxBool _isDarkMode =
      (Get.isPlatformDarkMode).obs;

  bool get isDarkMode => _isDarkMode.value;

  /// The [ThemeMode] consumed by `GetMaterialApp`.
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  /// Toggles between light and dark themes and applies the change immediately.
  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(themeMode);
  }

  /// Explicitly sets the theme mode (e.g. when restoring a saved preference).
  void setDarkMode(bool value) {
    _isDarkMode.value = value;
    Get.changeThemeMode(themeMode);
  }
}

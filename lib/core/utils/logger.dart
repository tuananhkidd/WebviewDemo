import 'package:flutter/foundation.dart';

/// Lightweight logging helper.
///
/// Wraps [debugPrint] so logs are stripped/cheap in release builds and so the
/// project never scatters raw `print()` calls across the codebase.
class AppLogger {
  AppLogger._(); // Prevent instantiation.

  static void d(Object? message) {
    if (kDebugMode) debugPrint('🟦 [DEBUG] $message');
  }

  static void i(Object? message) {
    if (kDebugMode) debugPrint('🟩 [INFO] $message');
  }

  static void e(Object? message, [Object? error, StackTrace? stack]) {
    if (kDebugMode) {
      debugPrint('🟥 [ERROR] $message');
      if (error != null) debugPrint('         $error');
      if (stack != null) debugPrint('$stack');
    }
  }
}

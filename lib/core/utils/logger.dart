import 'package:flutter/foundation.dart';

import '../config/env_config.dart';

/// Lightweight logging helper.
///
/// Wraps [debugPrint] so logs are stripped/cheap in release builds and so the
/// project never scatters raw `print()` calls across the codebase.
///
/// Logging is also gated by [EnvConfig.enableLogging] so it can be disabled
/// per environment (e.g. turned off in the `release` env file).
class AppLogger {
  AppLogger._(); // Prevent instantiation.

  static void d(Object? message) {
    if (kDebugMode && EnvConfig.enableLogging) {
      debugPrint('🟦 [DEBUG] $message');
    }
  }

  static void i(Object? message) {
    if (kDebugMode && EnvConfig.enableLogging) {
      debugPrint('🟩 [INFO] $message');
    }
  }

  static void e(Object? message, [Object? error, StackTrace? stack]) {
    if (kDebugMode && EnvConfig.enableLogging) {
      debugPrint('🟥 [ERROR] $message');
      if (error != null) debugPrint('         $error');
      if (stack != null) debugPrint('$stack');
    }
  }
}


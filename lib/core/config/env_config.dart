import 'package:flutter_dotenv/flutter_dotenv.dart';

/// The three supported build environments.
enum AppEnvironment { develop, staging, release }

/// Convenience accessors for values stored in the active `.env.*` file.
///
/// Call [dotenv.load] in `main()` before accessing any getter.
///
/// ```dart
/// await dotenv.load(fileName: '.env.develop');
/// print(EnvConfig.baseUrl); // https://jsonplaceholder.typicode.com
/// ```
class EnvConfig {
  EnvConfig._(); // Prevent instantiation.

  /// Current environment parsed from the `ENV` key.
  static AppEnvironment get environment => AppEnvironment.values.firstWhere(
        (e) => e.name == dotenv.get('ENV', fallback: 'develop'),
        orElse: () => AppEnvironment.develop,
      );

  /// Display name shown in the app title / app bar.
  static String get appName =>
      dotenv.get('APP_NAME', fallback: 'Webview Demo');

  /// Base URL used by [DioClient] for all API requests.
  static String get baseUrl => dotenv.get('BASE_URL');

  /// Company website loaded in the in-app WebView.
  static String get websiteUrl => dotenv.get('WEBSITE_URL');

  /// Whether debug logging is enabled for this environment.
  static bool get enableLogging =>
      dotenv.get('ENABLE_LOGGING', fallback: 'false') == 'true';
}

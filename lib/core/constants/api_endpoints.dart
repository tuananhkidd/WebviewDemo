import '../config/env_config.dart';

/// API endpoint configuration.
///
/// All network URLs live here so call sites never hardcode raw strings.
/// [baseUrl] and [companyWebsite] are driven by the active `.env.*` file
/// via [EnvConfig].
class ApiEndpoints {
  ApiEndpoints._(); // Prevent instantiation.

  /// Base URL used by the shared [DioClient].
  static String get baseUrl => EnvConfig.baseUrl;

  /// Sample resource required by the client spec: returns a single todo.
  static const String todoById = '/todos'; // e.g. /todos/1

  /// Company website loaded inside the in-app WebView.
  static String get companyWebsite => EnvConfig.websiteUrl;

  /// Default network timeout in milliseconds.
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}


/// API endpoint configuration.
///
/// All network URLs live here so call sites never hardcode raw strings.
class ApiEndpoints {
  ApiEndpoints._(); // Prevent instantiation.

  /// Base URL used by the shared [DioClient].
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Sample resource required by the client spec: returns a single todo.
  static const String todoById = '/todos'; // e.g. /todos/1

  /// Company website loaded inside the in-app WebView.
  static const String companyWebsite = 'https://www.sgcarmart.com';

  /// Default network timeout in milliseconds.
  static const int connectTimeoutMs = 15000;
  static const int receiveTimeoutMs = 15000;
}

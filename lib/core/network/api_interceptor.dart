import 'package:dio/dio.dart';

import '../utils/logger.dart';

/// Global Dio interceptor responsible for cross-cutting network concerns:
///
/// * Injecting the auth token into every outgoing request.
/// * Logging requests, responses and errors in debug builds.
/// * Normalizing errors into readable messages.
class ApiInterceptor extends Interceptor {
  /// Returns the current auth token. Wire this up to your secure storage /
  /// session manager. Returning `null` simply omits the header.
  final String? Function()? tokenProvider;

  ApiInterceptor({this.tokenProvider});

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = tokenProvider?.call();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    AppLogger.i('➡️ ${options.method} ${options.uri}');
    if (options.data != null) AppLogger.d('Body: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.i(
      '✅ ${response.statusCode} ${response.requestOptions.uri}',
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.e(
      '❌ ${err.response?.statusCode} ${err.requestOptions.uri} '
      '-> ${_mapError(err)}',
      err,
    );
    handler.next(err);
  }

  /// Maps a [DioException] to a human-readable message for the UI layer.
  static String _mapError(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out. Please try again.';
      case DioExceptionType.badResponse:
        return 'Server error (${err.response?.statusCode}).';
      case DioExceptionType.connectionError:
        return 'No internet connection.';
      case DioExceptionType.cancel:
        return 'Request cancelled.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}

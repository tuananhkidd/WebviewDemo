import 'package:dio/dio.dart';

import '../constants/api_endpoints.dart';
import 'api_interceptor.dart';

/// Base API client wrapping a configured [Dio] instance.
///
/// This is the single shared HTTP entry point for the whole app (used by both
/// iOS and Android). Services should depend on [DioClient] rather than creating
/// their own [Dio] instances, so timeouts, headers and interceptors stay
/// consistent.
class DioClient {
  late final Dio _dio;

  DioClient({String? Function()? tokenProvider}) {
    _dio = Dio(
      BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout:
            const Duration(milliseconds: ApiEndpoints.connectTimeoutMs),
        receiveTimeout:
            const Duration(milliseconds: ApiEndpoints.receiveTimeoutMs),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    _dio.interceptors.add(ApiInterceptor(tokenProvider: tokenProvider));
  }

  /// Performs a GET request and returns the decoded [Response].
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.get<T>(path, queryParameters: queryParameters);
  }

  /// Performs a POST request with an optional JSON [data] body.
  Future<Response<T>> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
  }) {
    return _dio.post<T>(path, data: data, queryParameters: queryParameters);
  }

  /// Exposes the raw [Dio] instance for advanced/edge cases.
  Dio get raw => _dio;
}

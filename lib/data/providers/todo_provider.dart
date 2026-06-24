import '../../core/constants/api_endpoints.dart';
import '../../core/network/dio_client.dart';
import '../models/todo_model.dart';

/// Provider responsible for raw todo network calls.
///
/// Providers know *how* to talk to the API. Services (and controllers) depend on
/// providers, never on [DioClient] directly.
class TodoProvider {
  final DioClient _client;

  TodoProvider(this._client);

  /// Fetches a single todo by [id] from `/todos/{id}`.
  ///
  /// Throws on network/parse failure so the caller can surface the error.
  Future<TodoModel> fetchTodoById(int id) async {
    final response = await _client.get<Map<String, dynamic>>(
      '${ApiEndpoints.todoById}/$id',
    );
    return TodoModel.fromJson(response.data ?? <String, dynamic>{});
  }
}

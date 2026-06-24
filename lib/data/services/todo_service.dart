import '../models/todo_model.dart';
import '../providers/todo_provider.dart';

/// Application-facing service for todo data.
///
/// This exposes the **common, cross-platform REST API function** required by the
/// spec. The same Dart code runs on both iOS and Android — there is no
/// platform-specific branching. Controllers depend on this service.
class TodoService {
  final TodoProvider _provider;

  TodoService(this._provider);

  /// Common REST function: calls `https://jsonplaceholder.typicode.com/todos/1`
  /// and returns a typed [TodoModel]. Shared by every platform.
  Future<TodoModel> getSampleTodo() {
    return _provider.fetchTodoById(1);
  }
}

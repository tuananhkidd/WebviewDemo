/// Data model representing a single todo item from JSONPlaceholder.
///
/// Mirrors the shape returned by `GET /todos/{id}`.
class TodoModel {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  const TodoModel({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  /// Creates a [TodoModel] from decoded JSON.
  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      userId: json['userId'] as int? ?? 0,
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      completed: json['completed'] as bool? ?? false,
    );
  }

  /// Serializes this model back to JSON.
  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'completed': completed,
      };
}

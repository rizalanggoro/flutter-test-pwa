import 'dart:convert';

class Todo {
  final String id;
  String title;
  String description;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'completed': completed,
      };

  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String? ?? '',
        completed: json['completed'] as bool? ?? false,
      );

  static String encode(List<Todo> todos) =>
      json.encode(todos.map((t) => t.toJson()).toList());

  static List<Todo> decode(String json) =>
      (jsonDecode(json) as List).map((t) => Todo.fromJson(t)).toList();
}

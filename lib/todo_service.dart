import 'package:web/web.dart' as web;
import 'todo.dart';

class TodoService {
  static const _key = 'todos';

  List<Todo> load() {
    final data = web.window.localStorage.getItem(_key);
    if (data == null || data.isEmpty) return [];
    return Todo.decode(data);
  }

  void save(List<Todo> todos) {
    web.window.localStorage.setItem(_key, Todo.encode(todos));
  }
}

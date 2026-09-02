import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

import 'add_todo_page.dart';
import 'build_info.dart';
import 'todo.dart';
import 'todo_detail_page.dart';
import 'todo_service.dart';

void main() {
  usePathUrlStrategy();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  runApp(const MyApp());
}

final _service = TodoService();

final router = GoRouter(
  routerNeglect: true,
  routes: [
    GoRoute(path: '/', builder: (context, state) => const TodoPage()),
    GoRoute(path: '/add', builder: (context, state) => const AddTodoPage()),
    GoRoute(
      path: '/todo/:id',
      builder: (context, state) {
        final id = state.pathParameters['id']!;
        return TodoDetailPage(todoId: id);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Todo List',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  List<Todo> _todos = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() => _todos = _service.load());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Todo List PWA'),
            if (BuildInfo.hasInfo)
              Text(
                'Build ${BuildInfo.shortSha} • ${BuildInfo.timestamp}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
        centerTitle: true,
      ),
      body: _todos.isEmpty
          ? const Center(
              child: Text(
                'Belum ada todo',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: _todos.length,
              itemBuilder: (context, index) {
                final todo = _todos[index];
                return ListTile(
                  leading: Icon(
                    todo.completed ? Icons.check_circle : Icons.circle_outlined,
                    color: todo.completed ? Colors.grey : Colors.grey,
                  ),
                  title: Text(
                    todo.title,
                    style: TextStyle(
                      decoration: todo.completed
                          ? TextDecoration.lineThrough
                          : null,
                      color: todo.completed ? Colors.grey : null,
                    ),
                  ),
                  subtitle: todo.description.isNotEmpty
                      ? Text(
                          todo.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        )
                      : null,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/todo/${todo.id}'),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/add'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

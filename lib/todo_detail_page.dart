import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'todo.dart';
import 'todo_service.dart';

class TodoDetailPage extends StatefulWidget {
  final String todoId;

  const TodoDetailPage({super.key, required this.todoId});

  @override
  State<TodoDetailPage> createState() => _TodoDetailPageState();
}

class _TodoDetailPageState extends State<TodoDetailPage> {
  final _service = TodoService();
  late TextEditingController _titleController;
  late TextEditingController _descController;
  late bool _completed;
  bool _editing = false;
  Todo? _todo;

  @override
  void initState() {
    super.initState();
    final todos = _service.load();
    _todo = todos.firstWhere(
      (t) => t.id == widget.todoId,
      orElse: () => Todo(id: '', title: ''),
    );
    _titleController = TextEditingController(text: _todo!.title);
    _descController = TextEditingController(text: _todo!.description);
    _completed = _todo!.completed;
  }

  void _toggleEdit() {
    if (_editing) {
      _todo!.title = _titleController.text.trim();
      _todo!.description = _descController.text.trim();
      _save();
    }
    setState(() => _editing = !_editing);
  }

  void _save() {
    final todos = _service.load();
    final idx = todos.indexWhere((t) => t.id == widget.todoId);
    if (idx != -1) {
      todos[idx] = _todo!;
      _service.save(todos);
    }
  }

  void _delete() {
    final todos = _service.load();
    todos.removeWhere((t) => t.id == widget.todoId);
    _service.save(todos);
    context.go('/');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_todo == null || _todo!.id.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Todo')),
        body: const Center(child: Text('Todo tidak ditemukan')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Todo'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(_editing ? Icons.check : Icons.edit),
            onPressed: _toggleEdit,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: _delete,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            _editing
                ? TextField(
                    controller: _titleController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                  )
                : Text(_todo!.title, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            Text('Deskripsi', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 4),
            _editing
                ? TextField(
                    controller: _descController,
                    decoration: const InputDecoration(border: OutlineInputBorder()),
                    maxLines: 5,
                  )
                : Text(
                    _todo!.description.isEmpty ? 'Tidak ada deskripsi' : _todo!.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: _todo!.description.isEmpty ? Colors.grey : null,
                    ),
                  ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Status:', style: Theme.of(context).textTheme.labelLarge),
                const SizedBox(width: 8),
                Switch(
                  value: _completed,
                  onChanged: (v) {
                    setState(() {
                      _completed = v;
                      _todo!.completed = v;
                    });
                    _save();
                  },
                ),
                Text(_completed ? 'Selesai' : 'Belum selesai'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

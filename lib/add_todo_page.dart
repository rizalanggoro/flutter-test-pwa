import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'todo.dart';
import 'todo_service.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({super.key});

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _service = TodoService();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;
    final todos = _service.load();
    todos.add(Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
      description: _descController.text.trim(),
    ));
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Buat Todo Baru'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                hintText: 'Judul tugas kamu...',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _descController,
              decoration: const InputDecoration(
                labelText: 'Deskripsi (opsional)',
                hintText: 'Masukkan deskripsi...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: const Text('Simpan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

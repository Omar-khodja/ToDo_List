import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:todo_app/feature/home/presentation/controller/todolist_provider.dart';

class TodolistWidget extends ConsumerWidget {
  const TodolistWidget({super.key, required this.todo});
  final Todo todo;
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        leading: Checkbox(value: todo.isDone, onChanged: (value) {
          ref.read(todolistNotifierProvider.notifier).isDone(todo.id);
        }),
        title: Text(
          todo.title,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
          decoration: todo.isDone? TextDecoration.lineThrough : TextDecoration.none,
           color: todo.isDone
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: .5)
                : Theme.of(context).colorScheme.onSurface,
                
        ),
        ),
        subtitle: Text("Category ${todo.catigory}"),
        trailing: todo.dueDate != null ? Text(todo.dueDate!) : null,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/Moudel/todo.dart';
import 'package:todo_app/provider/todolist_provider.dart';

class TodolistWidget extends ConsumerWidget {
  const TodolistWidget({super.key, required this.todo});
  final Todo todo;
  @override
  Widget build(BuildContext context , WidgetRef ref) {
    
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        leading: Checkbox(value: todo.isDone, onChanged: (value) {
          ref.read(todolist_Notifier.notifier).isDone(todo.id);
        }),
        title: Text(todo.title, style: Theme.of(context).textTheme.titleMedium!.copyWith(
          decoration: todo.isDone? TextDecoration.lineThrough : TextDecoration.none,
           color: todo.isDone
                ? Theme.of(context).colorScheme.onSurface.withValues(alpha: .5)
                : Theme.of(context).colorScheme.onSurface,
                
        ),
        ),
        subtitle: Text("Category ${todo.catigory}"),
      ),
    );
  }
}

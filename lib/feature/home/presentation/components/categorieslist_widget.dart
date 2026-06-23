import 'package:flutter/material.dart';
import 'package:todo_app/feature/home/presentation/controller/category_provider.dart';

class CategorieslistWidget extends StatelessWidget {
  const CategorieslistWidget({
    super.key,
    required this.title,
    required this.task,
    required this.delete,
  });
  final String title;
  final int task;
  final CategoryNotifier delete;
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: ListTile(
        title: Text(title, style: Theme.of(context).textTheme.titleMedium),
        subtitle: task == 0
            ? const Text("No Task")
            : Text("Tasks: ${task.toString()}"),
        trailing: IconButton(
          onPressed: () {
            delete.delete(title);
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                content: Text("Category $title Deleted",style: Theme.of(context).textTheme.titleSmall,),
              ),
            );
          },
          icon: const Icon(Icons.delete, size: 30),
        ),
      ),
    );
  }
}

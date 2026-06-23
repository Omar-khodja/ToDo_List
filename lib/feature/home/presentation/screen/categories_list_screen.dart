import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/feature/home/presentation/controller/category_provider.dart';
import 'package:todo_app/feature/home/presentation/controller/todolist_provider.dart';
import 'package:todo_app/feature/home/presentation/components/categorieslist_widget.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesNotifierProvider);
    final delete = ref.read(categoriesNotifierProvider.notifier);
    final todolist = ref.watch(todolistNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category List",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: categories.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              int task = 0;
              if (data[index].title.trim() == "All") {
                task = todolist.value!.length;
              } else {
                task = todolist.value!
                    .where((element) => element.catigory == data[index].title)
                    .toList()
                    .length;
              }
              return CategorieslistWidget(
                title: data[index].title,
                task: task,
                delete: delete,
              );
            },
          ),
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/provider/category_provider.dart';
import 'package:todo_app/provider/todolist_provider.dart';
import 'package:todo_app/widget/categorieslist_widget.dart';

class CategoryListScreen extends ConsumerWidget {
  const CategoryListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesNotifier);
    final delete = ref.read(categoriesNotifier.notifier);
    final todolist = ref.watch(todolist_Notifier);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Category List",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: ListView.builder(
          itemCount: categories.length,
          itemBuilder: (context, index) {
            int task = 0;
            if (categories[index].trim() == "All") {
              task = todolist.length;
            } else {
              task = todolist
                  .where((element) => element.catigory == categories[index])
                  .toList()
                  .length;
            }
            return  CategorieslistWidget(
              title: categories[index],
              task: task,
              delete: delete,
            );
          },
        ),
      ),
    );
  }
}

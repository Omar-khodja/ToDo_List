import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/feature/home/presentation/controller/category_provider.dart';
import 'package:todo_app/feature/home/presentation/controller/todolist_provider.dart';

class Customdropdownbutton extends ConsumerWidget {
  Customdropdownbutton({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
  String? category;
    final categories = ref.watch(categoriesNotifierProvider);
    return categories.when(
      data: (data) => DropdownButton(
        dropdownColor: Theme.of(context).colorScheme.primaryContainer,
        hint: Text("Filter", style: Theme.of(context).textTheme.titleSmall),
        value: category,
        items: data
            .map(
              (item) =>
                  DropdownMenuItem(value: item.title, child: Text(item.title)),
            )
            .toList(),
        onChanged: (value) {
          category = value;
          ref.read(todolistNotifierProvider.notifier).filter(value!);
        },
      ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

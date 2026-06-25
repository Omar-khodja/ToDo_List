import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/feature/home/presentation/controller/category_provider.dart';
import 'package:todo_app/feature/home/presentation/controller/todolist_provider.dart';

class Customdropdownbutton extends ConsumerStatefulWidget {
  const Customdropdownbutton({super.key});

  @override
  ConsumerState<Customdropdownbutton> createState() =>
      _CustomdropdownbuttonState();
}

class _CustomdropdownbuttonState extends ConsumerState<Customdropdownbutton> {
  String? category;
  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesNotifierProvider);
    return categories.when(
      data: (data) => DropdownButton(
        hint: Text(
          "Filter",
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(color: Colors.white),
        ),
        style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        dropdownColor: Theme.of(context).colorScheme.primary,
        value: category,
        items: data
            .map(
              (item) =>
                  DropdownMenuItem(value: item.title, child: Text(item.title)),
            )
            .toList(),
        onChanged: (value) {
          setState(() {
            
          category = value;
          });
          ref.read(todolistNotifierProvider.notifier).filter(value!);
        },
      ),
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}

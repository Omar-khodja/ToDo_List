import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/provider/category_provider.dart';
import 'package:todo_app/provider/todolist_provider.dart';
import 'package:todo_app/screen/addNewItem_screen.dart';
import 'package:todo_app/screen/categories_list_screen.dart';
import 'package:todo_app/widget/todolistscreen_content.dart';

class TodolistScreen extends ConsumerStatefulWidget {
  const TodolistScreen({super.key});
  @override
  ConsumerState<TodolistScreen> createState() => _TodolistScreenState();
}

class _TodolistScreenState extends ConsumerState<TodolistScreen> {
  late Future<void> todoItems;
  String? _category;

  @override
  void initState() {
    super.initState();
    todoItems = ref.read(todolist_Notifier.notifier).loadDatebase();
    ref.read(categoriesNotifier.notifier).loadDatebase();
  }

  void _addnewTask() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddnewitemScreen()));
  }

  void _delteTask(String id) {
    ref.read(todolist_Notifier.notifier).deleteItem(id);
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Task Deleted",
          style: Theme.of(context).textTheme.titleSmall,
        ),
        duration: const Duration(seconds: 3),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final todolist = ref.watch(todolist_Notifier);
    final categories = ref.watch(categoriesNotifier);

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          DropdownButton(
            dropdownColor: Theme.of(context).colorScheme.primaryContainer,
            hint: Text("Filter", style: Theme.of(context).textTheme.titleSmall),
            value: _category,
            items: categories
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              _category = value;
              ref.read(todolist_Notifier.notifier).filter(value!);
            },
          ),
          PopupMenuButton(
            color: Theme.of(context).colorScheme.primaryContainer,
            onSelected: (value) {
              if (value == "Categories List") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const CategoryListScreen(),
                  ),
                );
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<String>(
                  value: "Categories List",
                  child: Text("Categories List"),
                ),
                const PopupMenuItem<String>(
                  value: "Follow us",
                  child: Text("Follow us"),
                ),
                const PopupMenuItem<String>(
                  value: "Send feedback",
                  child: Text("Send feedback"),
                ),
                const PopupMenuItem<String>(
                  value: "Invite friends to the app",
                  child: Text("Invite friends to the app"),
                ),
                const PopupMenuItem<String>(
                  value: "Settings",
                  child: Text("Settings"),
                ),
              ];
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: todoItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            return TodolistscreenContent(
              todolist: todolist,
              delteTask: _delteTask,
            );
          },
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 10, 15),
        child: FloatingActionButton(
          onPressed: _addnewTask,
          shape: const CircleBorder(),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}

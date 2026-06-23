import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/feature/home/presentation/components/customdropdownbutton.dart';
import 'package:todo_app/feature/home/presentation/controller/category_provider.dart';
import 'package:todo_app/feature/home/presentation/controller/todolist_provider.dart';
import 'package:todo_app/feature/home/presentation/screen/addNewItem_screen.dart';
import 'package:todo_app/feature/home/presentation/screen/categories_list_screen.dart';
import 'package:todo_app/feature/home/presentation/components/todolistscreen_content.dart';

class TodolistScreen extends ConsumerStatefulWidget {
  const TodolistScreen({super.key});
  @override
  ConsumerState<TodolistScreen> createState() => _TodolistScreenState();
}

class _TodolistScreenState extends ConsumerState<TodolistScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(todolistNotifierProvider.notifier).loadDatebase();
      ref.read(categoriesNotifierProvider.notifier).loadDatebase();
    });
  }

  void _addnewTask() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddnewitemScreen()));
  }

  void _delteTask(String id) {
    ref.read(todolistNotifierProvider.notifier).deleteItem(id);
  }

  @override
  Widget build(BuildContext context) {
    final todolist = ref.watch(todolistNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text("Todo List", style: Theme.of(context).textTheme.titleLarge),
        actions: [
          Customdropdownbutton(),
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
      body: todolist.when(
        data: (data) => Padding(
          padding: const EdgeInsets.all(8.0),
          child: TodolistscreenContent(todolist: data, delteTask: _delteTask),
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
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

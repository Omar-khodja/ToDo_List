import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:todo_app/feature/home/presentation/controller/category_provider.dart';
import 'package:todo_app/feature/home/presentation/controller/todolist_provider.dart';

class AddnewitemScreen extends ConsumerStatefulWidget {
  const AddnewitemScreen({super.key});
  @override
  ConsumerState<AddnewitemScreen> createState() => _AddnewitemScreenState();
}

class _AddnewitemScreenState extends ConsumerState<AddnewitemScreen> {
  String _title = "";
  bool isSaving = false;
  String? _category;
  final _addNewcategory = TextEditingController();

  final _formKey = GlobalKey<FormState>();


  @override
  void dispose() {
    super.dispose();
    _addNewcategory.clear();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isSaving = true;
      });
      ref
          .read(todolistNotifierProvider.notifier)
          .addItem(Todo(title: _title, catigory: _category!));
      setState(() {
        isSaving = false;
      });
      Navigator.pop(context);
    }
  }

  void _addNewCategory() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Add New Category",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          content: TextField(
            controller: _addNewcategory,
            style: Theme.of(context).textTheme.titleMedium,
            decoration: const InputDecoration(label: Text("New Category")),
            maxLength: 20,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(categoriesNotifierProvider.notifier)
                    .addNewCategory(_addNewcategory.text);
                setState(() {
                  _category = _addNewcategory.text;
                });

                Navigator.pop(context);
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final catrgories = ref.watch(categoriesNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text("New Task", style: Theme.of(context).textTheme.titleLarge),
      ),
      body: catrgories.when(
        data: (data) => Padding(
          padding: const EdgeInsetsGeometry.all(10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  maxLength: 30,
                  style: Theme.of(context).textTheme.titleMedium,
                  decoration: const InputDecoration(label: Text("Title")),
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length <= 2) {
                      return "Plese enter a Title that have more then 2 letter.";
                    }
                    return null;
                  },
                  onSaved: (newValue) {
                    _title = newValue!;
                  },
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: catrgories.value!.contains(_category)
                            ? _category
                            : null,
                        dropdownColor: Colors.black,
                        decoration: const InputDecoration(
                          labelText: "Category",
                        ),
                        items: catrgories.value!.map((e) {
                          return DropdownMenuItem<String>(
                            value: e.title,
                            child: Text(e.title),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _category = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please select a category.";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: _addNewCategory,
                      label: const Text("Add New Category"),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: isSaving
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                      child: const Text("Cancel"),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _saveItem,
                      child: isSaving
                          ? const CircularProgressIndicator()
                          : const Text("Save"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

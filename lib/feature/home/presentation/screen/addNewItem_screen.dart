
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/core/applogger/applogger.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:todo_app/feature/home/presentation/controller/category_provider.dart';
import 'package:todo_app/feature/home/presentation/controller/todolist_provider.dart';

class AddnewitemScreen extends ConsumerStatefulWidget {
  const AddnewitemScreen({super.key});
  @override
  ConsumerState<AddnewitemScreen> createState() => _AddnewitemScreenState();
}

class _AddnewitemScreenState extends ConsumerState<AddnewitemScreen> {
  bool isSaving = false;
  String? _category;
  final TextEditingController _addNewcategory = TextEditingController();
  final TextEditingController _title = TextEditingController();

  final TextEditingController _dueDate = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _addNewcategory.clear();
    _title.dispose();
    _dueDate.dispose();
  }

  void _saveItem() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        isSaving = true;
      });
      if (_dueDate.text == "") {
        ref
            .read(todolistNotifierProvider.notifier)
            .addItem(Todo(title: _title.text, catigory: _category!));
      } else {
        ref
            .read(todolistNotifierProvider.notifier)
            .addItem(
              Todo(
                title: _title.text,
                catigory: _category!,
                dueDate: _dueDate.text,
              ),
            );
      }
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
      appBar: AppBar(title: const Text("New Task")),
      body: catrgories.when(
        data: (category) {
          final data = category.where((e) => e.title != "All").toList();
          return Padding(
            padding: const EdgeInsetsGeometry.all(10),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _title,
                    maxLength: 30,
                    style: Theme.of(context).textTheme.titleMedium,
                    decoration: InputDecoration(
                      label: Text(
                        "Title",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length <= 2) {
                        return "Plese enter a Title that have more then 2 letter.";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _dueDate,
                    style: Theme.of(context).textTheme.titleMedium,
                    keyboardType: TextInputType.datetime,
                    onTap: () async {
                      final date = DateTime.now().year;
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime(date),
                        lastDate: DateTime(date + 1),
                      );
                      if (!mounted) return;
                      if (pickedDate != null) {
                        final TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (!mounted) return;

                        if (pickedTime != null) {
                          final fullDate = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                          _dueDate.text = DateFormat(
                            "yyyy-MM-dd HH-MM",
                          ).format(fullDate);
                        }
                        AppLogger.i(_dueDate.text);
                      }
                    },
                    decoration: InputDecoration(
                      label: Text(
                        "Reminder optional",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: null,
                          decoration: InputDecoration(
                            labelText: "Category",
                            labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.onSurface,
                              fontSize: 18,
                            ),
                          ),
                          items: data.map((e) {
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
                        label: Text(
                          "Add New Category",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.surfaceContainer,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _saveItem,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),

                        child: isSaving
                            ? const CircularProgressIndicator()
                            : const Text("Save"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

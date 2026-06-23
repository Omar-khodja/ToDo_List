import 'package:flutter/material.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:todo_app/feature/home/presentation/components/TodoLIst_widget.dart';

class TodolistscreenContent extends StatelessWidget {
  const TodolistscreenContent({super.key, required this.todolist,required this.delteTask});
  final List<Todo> todolist;
  final Function(String id) delteTask;
  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Text(
        "Todo List is empty",
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
    if (todolist.isNotEmpty) {
      content = ListView.builder(
        itemCount: todolist.length,
        itemBuilder: (context, index) => Dismissible(
          key: Key(todolist[index].id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            final id = todolist[index].id;
            Future.delayed(Duration.zero, () {
              delteTask(id);
            });
          },
         
          child: TodolistWidget(todo: todolist[index]),
        ),
      );
    }
    return content;
  }
}

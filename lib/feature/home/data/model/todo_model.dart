import 'package:todo_app/feature/home/domain/entities/todo.dart';

class TodoModel extends Todo {
  TodoModel({
    required super.id,
    required super.title,
    required super.catigory,
    required super.dueDate,
    super.isDone,
  });
  factory TodoModel.fromdb(Map<String, Object?> data) {
    return TodoModel(
      id: data["id"] as String,
      title: data["Title"] as String,
      catigory: data["Category"] as String,
      dueDate: data["dueDate"] as String,
      isDone: data["isDone"] == 1 ? true : false,
    );
  }
  factory TodoModel.fromEntity(Todo todo) {
    return TodoModel(
      id: todo.id,
      title: todo.title,
      catigory: todo.catigory,
      dueDate: todo.dueDate,
    );
  }
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "Title": title,
      "Category": catigory,
      "DueDate": dueDate ?? "",
      "isDone": isDone,
    };
  }
}

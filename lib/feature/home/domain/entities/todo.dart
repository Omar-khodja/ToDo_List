import 'package:uuid/uuid.dart';

final uuid = const Uuid();

class Todo {
  Todo({
    String? id,
    required this.title,
    required this.catigory,
    this.dueDate,
    this.isDone = false,
  }) : id = id ?? const Uuid().v4();

  final String id;
  final String title;
  final String catigory;
  final String? dueDate;
  final bool isDone;
    Todo copyWith({
    String? id,
    String? title,
    String? catigory,
    String? dueDate,
    bool? isDone,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      catigory: catigory ?? this.catigory,
      dueDate: dueDate ?? this.dueDate,
      isDone: isDone ?? this.isDone,
    );
  }
}

import 'package:uuid/uuid.dart';

final uuid = const Uuid();

class Todo {
  Todo({String? id, required this.title,required this.catigory, bool? isDone})
    : id = id ?? uuid.v4(),
      isDone = isDone ?? false;

  final String id;
  final String title;
  final String catigory;
  final bool isDone;
}

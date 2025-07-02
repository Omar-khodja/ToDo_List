import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:todo_app/Moudel/todo.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as p;

Future<Database> _getDatebase() async {
  final dbpath = await sql.getDatabasesPath();
  final path = p.join(dbpath, "TodoList.db");
  final db = await sql.openDatabase(
    path,
    version: 2,
    onCreate: (db, version) async {
      await db.execute(
        "CREATE TABLE TodoList (id TEXT PRIMARY KEY , Title TEXT ,Category TEXT,isDone BOOLEAN) ",
      );
      await db.execute(
        "CREATE TABLE Category (id TEXT PRIMARY KEY , Title TEXT)",
      );
      await db.insert("Category", {"id": "Work", "Title": "Work"});
      await db.insert("Category", {"id": "Home", "Title": "Home"});
      await db.insert("Category", {"id": "Study", "Title": "Study"});
      await db.insert("Category", {"id": "Personal", "Title": "Personal"});
      await db.insert("Category", {"id": "Shopping", "Title": "Shopping"});
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
          "CREATE TABLE Category (id TEXT PRIMARY KEY , Title TEXT)",
        );
        await db.execute("ALTER TABLE TodoList ADD COLUMN Category TEXT)");
        await db.insert("Category", {"id": "Work", "Title": "Work"});
        await db.insert("Category", {"id": "Home", "Title": "Home"});
        await db.insert("Category", {"id": "Study", "Title": "Study"});
        await db.insert("Category", {"id": "Personal", "Title": "Personal"});
        await db.insert("Category", {"id": "Shopping", "Title": "Shopping"});
      }
    },
  );
  return db;
}

class TodolistNotifire extends StateNotifier<List<Todo>> {
  TodolistNotifire() : super([]);
  Future<void> loadDatebase() async {
    final db = await _getDatebase();
    final data = await db.query("TodoList");
    final todoList = data
        .map(
          (row) => Todo(
            id: row["id"] as String,
            title: row["Title"] as String,
            catigory: row["Category"] as String,
            isDone: (row["isDone"] as int) == 1,
          ),
        )
        .toList();
    state = todoList;
  }

  void deletedb() async {
    final dbpath = await sql.getDatabasesPath();
    final path = p.join(dbpath, "TodoList.db");
    sql.deleteDatabase(path);
  }

  void addItem(Todo todo) async {
    await loadDatebase();
    final db = await _getDatebase();
    db.insert("TodoList", {
      "id": todo.id,
      "Title": todo.title,
      "Category": todo.catigory,
      "isDone": todo.isDone,
    });

    state = [...state, todo];
  }

  void filter(String category) async {
    await loadDatebase();
    if (category.trim() != 'All') {
      state = state.where((element) => element.catigory == category).toList();
    }
  }

  void deleteItem(String id) async {
    final db = await _getDatebase();
    await db.delete("TodoList", where: "id= ?", whereArgs: [id]);
    state = state.where((element) => element.id != id).toList();
  }

  void isDone(String id) async {
    final index = state.indexWhere((element) => element.id == id);
    if (index == -1) return;

    final currenTodo = state[index];
    final isDone = !currenTodo.isDone;

    final db = await _getDatebase();
    db.update("TodoList", {"isDone": isDone}, where: "id = ?", whereArgs: [id]);

    final updateTodo = Todo(
      title: currenTodo.title,
      id: currenTodo.id,
      catigory: currenTodo.catigory,
      isDone: isDone,
    );
    state = [
      for (final todo in state)
        if (todo.id == id) updateTodo else todo,
    ];
  }

  Future<List<String>> getCategory() async {
    final db = await _getDatebase();
    final data = await db.query("Category");
    List<String> categories = data.map((e) => e["Title"] as String).toList();

    return categories;
  }
}

final todolist_Notifier = StateNotifierProvider<TodolistNotifire, List<Todo>>(
  (ref) => TodolistNotifire(),
);

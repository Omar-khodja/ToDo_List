import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/core/applogger/applogger.dart';
import 'package:todo_app/core/error/exeptions.dart';
import 'package:todo_app/feature/home/data/datasource/home_base_datasource.dart';
import 'package:todo_app/feature/home/data/model/category_model.dart';
import 'package:todo_app/feature/home/data/model/todo_model.dart';

class HomeDatasource implements HomeBaseDatasource {
  HomeDatasource();

  Future<Database> getDatebase() async {
    final dbpath = await getDatabasesPath();
    final path = join(dbpath, "TodoList.db");
    final db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          "CREATE TABLE TodoList (id TEXT PRIMARY KEY , Title TEXT ,Category TEXT,dueDate DATE,isDone BOOLEAN) ",
        );
        await db.execute(
          "CREATE TABLE Category (id TEXT PRIMARY KEY , Title TEXT)",
        );
        await db.insert("Category", {"id": "All", "Title": "All"});

        await db.insert("Category", {"id": "Work", "Title": "Work"});
        await db.insert("Category", {"id": "Home", "Title": "Home"});
        await db.insert("Category", {"id": "Personal", "Title": "Personal"});
        await db.insert("Category", {"id": "Shopping", "Title": "Shopping"});
      },
    );
    return db;
  }

  @override
  Future<String> addItem(TodoModel todo) async {
    try {
      final db = await getDatebase();
      db.insert("TodoList", todo.toMap());
      return "inserted to todo list";
    } catch (e) {
      throw DataBaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> addNewCategory(String title) async {
    try {
      final db = await getDatebase();
      await db.insert("Category", {"id": title, "Title": title});
      return "$title added to categories";
    } catch (e) {
      throw DataBaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> deleteCategory(String title) async {
    try {
      final db = await getDatebase();
      await db.delete("Category", where: "id=?", whereArgs: [title]);
      return "$title deleted from categories";
    } catch (e) {
      throw DataBaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> deleteItem(String id) async {
    try {
      final db = await getDatebase();
      await db.delete("TodoList", where: "id= ?", whereArgs: [id]);
      return "Item deleted successfully";
    } catch (e) {
      throw DataBaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<String> isDone(String id) async {
    try {
      final db = await getDatebase();
      final result = await db.query(
      "TodoList",
      columns: ["isDone"],
      where: "id = ?",
      whereArgs: [id],
    );
     if (result.isNotEmpty) {
        final currentValue =
            result.first["isDone"] as int; 
        final newValue = currentValue == 1 ? 0 : 1;

        await db.update(
          "TodoList",
          {"isDone": newValue},
          where: "id = ?",
          whereArgs: [id],
        );
      }
      return "done";
    } catch (e) {
      throw DataBaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<TodoModel>> loadTodoList() async {
    try {
      final db = await getDatebase();
      final data = await db.query("TodoList");
      final todoList = data.map((item) => TodoModel.fromdb(item)).toList();
      AppLogger.i(data.toString());
            AppLogger.i(todoList.first.toString());

      return todoList;
    } catch (e) {
      throw DataBaseException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategory() async {
    try {
      final db = await getDatebase();
      final data = await db.query("Category");
      final todoList = data.map((item) => CategoryModel.fromMap(item)).toList();
      return todoList;
    } catch (e) {
      throw DataBaseException(errorMessage: e.toString());
    }
  }
  

}

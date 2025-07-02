import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as p;

Future<Database> _getDatebase() async {
  final dbpath = await sql.getDatabasesPath();
  final path = p.join(dbpath, "TodoList.db");
  final db = sql.openDatabase(path);
return db;
}
class CategoryNotifier extends StateNotifier<List<String>> {
  CategoryNotifier(): super([]);
  Future<void> loadDatebase() async {
    final db = await _getDatebase();
    final data = await db.query("Category");
    final todoList = data
        .map(
          (item) => item["Title"] as String 
        )
        .toList();
    state = todoList;
  }
  void addNewCategory(String title) async {
    if(state.contains(title)) return;
    final db = await _getDatebase();
    await db.insert("Category", {"id":title,"Title":title});
    state = [...state , title];

  }
    void delete(String id) async {
    final db = await _getDatebase();
    await db.delete("Category",where: "id = ?" , whereArgs: [id]);
    state = state.where((element) => element != id,).toList();
  }
}


final categoriesNotifier = StateNotifierProvider<CategoryNotifier , List<String> >((ref) => CategoryNotifier(),);
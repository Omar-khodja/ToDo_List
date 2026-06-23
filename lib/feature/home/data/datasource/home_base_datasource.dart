import 'package:todo_app/feature/home/data/model/category_model.dart';
import 'package:todo_app/feature/home/data/model/todo_model.dart';

abstract class HomeBaseDatasource {
  Future<List<TodoModel>> loadTodoList();

  Future<String> addItem(TodoModel todo);
  Future<String> deleteItem(String id);
  Future<String> isDone(String id);
  Future<List<CategoryModel>> getCategory();
  Future<String> addNewCategory(String title);
  Future<String> deleteCategory(String title);
}

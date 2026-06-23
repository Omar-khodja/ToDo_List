import 'package:dart_either/dart_either.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/domain/entities/category_entity.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';

abstract class HomeBaseRepo {
  Future<Either<Failure, List<Todo>>> loadDatabase();
  Future<Either<Failure, String>> addItem(Todo todo);
  Future<Either<Failure, String>> deleteItem(String id);
  Future<Either<Failure, String>> isDone(String id);
  Future<Either<Failure, List<CategoryEntity>>> getCategory();
  Future<Either<Failure, String>> addNewCategory(String title);
  Future<Either<Failure, String>> deleteCategory(String title);
}

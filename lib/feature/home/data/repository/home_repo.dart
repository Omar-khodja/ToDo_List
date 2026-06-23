import 'package:dart_either/src/dart_either.dart';
import 'package:todo_app/core/applogger/applogger.dart';
import 'package:todo_app/core/error/exeptions.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/data/datasource/home_base_datasource.dart';
import 'package:todo_app/feature/home/data/model/todo_model.dart';
import 'package:todo_app/feature/home/domain/entities/category_entity.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:todo_app/feature/home/domain/repository/home_base_repo.dart';

class HomeRepo implements HomeBaseRepo {
  HomeRepo({required this.dataSource});
  final HomeBaseDatasource dataSource;

  @override
  Future<Either<Failure, String>> addItem(Todo todo) async {
    try {
      final String result = await dataSource.addItem(
        TodoModel.fromEntity(todo),
      );
      return Right(result);
    } on DataBaseException catch (e) {
      AppLogger.e(e.errorMessage);
      return const Left(DatabaseFailure("Failed to insert item"));
    }
  }

  @override
  Future<Either<Failure, String>> addNewCategory(String title) async {
    try {
      final String result = await dataSource.addNewCategory(title);
      return Right(result);
    } on DataBaseException catch (e) {
      AppLogger.e(e.errorMessage);
      return const Left(DatabaseFailure("Failed to add new category"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteCategory(String title) async {
    try {
      final String result = await dataSource.deleteCategory(title);
      return Right(result);
    } on DataBaseException catch (e) {
      AppLogger.e(e.errorMessage);
      return const Left(DatabaseFailure("Failed to delete this category"));
    }
  }

  @override
  Future<Either<Failure, String>> deleteItem(String id) async {
    try {
      final String result = await dataSource.deleteItem(id);
      return Right(result);
    } on DataBaseException catch (e) {
      AppLogger.e(e.errorMessage);
      return const Left(DatabaseFailure("Failed to delete item"));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategory() async {
    try {
      final result = await dataSource.getCategory();
      return Right(result);
    } on DataBaseException catch (e) {
      AppLogger.e(e.errorMessage);
      return const Left(DatabaseFailure("Failed to featch Category"));
    }
  }

  @override
  Future<Either<Failure, String>> isDone(String id) async {
    try {
      final String result = await dataSource.isDone(id);
      return Right(result);
    } on DataBaseException catch (e) {
      AppLogger.e(e.errorMessage);
      return const Left(DatabaseFailure("Failed to insert done mark"));
    }
  }

  @override
  Future<Either<Failure, List<Todo>>> loadDatabase() async {
    try {
      final result = await dataSource.loadTodoList();
      return Right(result);
    } on DataBaseException catch (e) {
      AppLogger.e(e.errorMessage);
      return const Left(DatabaseFailure("Failed to load Data"));
    }
  }
}

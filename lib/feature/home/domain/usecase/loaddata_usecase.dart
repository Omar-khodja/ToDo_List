import 'package:dart_either/dart_either.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:todo_app/feature/home/domain/repository/home_base_repo.dart';

class LoaddataUsecase {
  LoaddataUsecase({required this.repo});
  final HomeBaseRepo repo;
  Future<Either<Failure,List<Todo>>> loadDatabase()async{
    return await repo.loadDatabase();

  }
}
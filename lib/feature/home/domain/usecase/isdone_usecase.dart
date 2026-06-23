import 'package:dart_either/dart_either.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/domain/repository/home_base_repo.dart';

class IsdoneUsecase {
  IsdoneUsecase({required this.repo});
  final HomeBaseRepo repo;
  Future<Either<Failure, String>> isDone(String id) async {
    return  await repo.isDone(id);
  }
}

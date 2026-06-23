import 'package:dart_either/dart_either.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/domain/repository/home_base_repo.dart';

class DeleteitemUsecase {
  DeleteitemUsecase({required this.repo});
  final HomeBaseRepo repo;
  Future<Either<Failure, String>> deleteItem(String id) async {
    return await repo.deleteItem(id);
  }
}

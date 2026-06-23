import 'package:dart_either/dart_either.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/domain/repository/home_base_repo.dart';

class DeleteCategoryUsecase {
  DeleteCategoryUsecase({required this.repo});
  final HomeBaseRepo repo;

  Future<Either<Failure, String>> deleteCategory(String title) async {
    return await repo.deleteCategory(title);
  }
}

import 'package:dart_either/dart_either.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/domain/repository/home_base_repo.dart';

class AddNewCategoryUsecase {
  AddNewCategoryUsecase({required this.repo});
  final HomeBaseRepo repo;

  Future<Either<Failure, String>> addNewCategory(String title) async {
    return await repo.addNewCategory(title);
  }
}

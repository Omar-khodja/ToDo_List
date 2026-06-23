import 'package:dart_either/dart_either.dart';
import 'package:todo_app/core/error/failure.dart';
import 'package:todo_app/feature/home/domain/entities/category_entity.dart';
import 'package:todo_app/feature/home/domain/repository/home_base_repo.dart';

class GetCategoryUsecase {
  GetCategoryUsecase({required this.repo});
  final HomeBaseRepo repo;

  Future<Either<Failure, List<CategoryEntity>>> getCategory() async {
    return await repo.getCategory();
  }
}

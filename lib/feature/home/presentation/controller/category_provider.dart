import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todo_app/feature/home/domain/entities/category_entity.dart';
import 'package:todo_app/feature/home/domain/usecase/addnewcategory_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/deletecategory_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/getcategory_usecase.dart';
import 'package:todo_app/feature/home/presentation/controller/home_provider.dart';

class CategoryNotifier extends StateNotifier<AsyncValue<List<CategoryEntity>>> {
  CategoryNotifier({
    required this.addNewCategoryUsecase,
    required this.deleteCategoryUsecase,
    required this.getCategoryUsecase,
  }) : super(const AsyncValue.loading());
  final GetCategoryUsecase getCategoryUsecase;
  final DeleteCategoryUsecase deleteCategoryUsecase;
  final AddNewCategoryUsecase addNewCategoryUsecase;
  Future<void> loadDatebase() async {
    state = const AsyncValue.loading();
    final result = await getCategoryUsecase.getCategory();
    result.fold(
      ifLeft: (value) {
        state = AsyncValue.error(
          "failed to feath category",
          StackTrace.current,
        );
      },
      ifRight: (value) {
        state = AsyncValue.data(value);
      },
    );
  }

  void addNewCategory(String title) async {
    final result = await addNewCategoryUsecase.addNewCategory(title);
    result.fold(
      ifLeft: (value) {
        Fluttertoast.showToast(
          msg: "failed to add new category",
          backgroundColor: Colors.red,
        );
        final current = state.value ?? [];
        state = AsyncValue.data(current);
      },
      ifRight: (value) {
        final current = state.value ?? [];
        state = AsyncValue.data([
          ...current,
          CategoryEntity(id: title, title: title),
        ]);
      },
    );
  }

  void delete(String id) async {
    final result = await deleteCategoryUsecase.deleteCategory(id);
    result.fold(
      ifLeft: (value) {
        Fluttertoast.showToast(
          msg: "failed to delete this category",
          backgroundColor: Colors.red,
        );
        final current = state.value ?? [];
        state = AsyncValue.data(current);
      },
      ifRight: (value) {
        final current = state.value ?? [];
        state = AsyncValue.data(
          current.where((element) => element.id != id).toList(),
        );
      },
    );
  }
}

final categoriesNotifierProvider =
    StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryEntity>>>(
      (ref) => CategoryNotifier(
        addNewCategoryUsecase: ref.read(addNewCategoryUsecaseProvider),
        deleteCategoryUsecase: ref.read(deleteCategoryUsecaseProvider),
        getCategoryUsecase: ref.read(getCategoryUsecaseProvider),
      ),
    );

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:todo_app/feature/home/domain/entities/todo.dart';
import 'package:todo_app/feature/home/domain/usecase/additem_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/deleteitem_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/isdone_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/loaddata_usecase.dart';
import 'package:todo_app/feature/home/presentation/controller/home_provider.dart';

class TodolistNotifire extends StateNotifier<AsyncValue<List<Todo>>> {
  TodolistNotifire({
    required this.addItemUseCase,
    required this.deleteitemUsecase,
    required this.isDoneUseCase,
    required this.loaddataUsecase,
  }) : super(const AsyncValue.loading());
  final Additemusecase addItemUseCase;
  final DeleteitemUsecase deleteitemUsecase;
  final IsdoneUsecase isDoneUseCase;
  final LoaddataUsecase loaddataUsecase;
  Future<void> loadDatebase() async {
    state = const AsyncValue.loading();
    final result = await loaddataUsecase.loadDatabase();
    result.fold(
      ifLeft: (value) {
        state = AsyncValue.error(
          "failed to featch todo list",
          StackTrace.current,
        );
      },
      ifRight: (value) => state = AsyncValue.data(value),
    );
  }

  Future<void> addItem(Todo todo) async {
    state = const AsyncValue.loading();
    final result = await addItemUseCase.addItem(todo);
    result.fold(
      ifLeft: (value) {
        Fluttertoast.showToast(
          msg: "failed to add item to Todo List",
          backgroundColor: Colors.red,
        );
        final current = state.value ?? [];
        state = AsyncValue.data(current);
      },
      ifRight: (value) {
        Fluttertoast.showToast(msg: "Item added to todoLidt successfully");
        final current = state.value ?? [];
        state = AsyncValue.data([...current, todo]);
      },
    );
  }

  Future<void> filter(String category) async {
    if (category.trim() != 'All') {
      final currentstate = state.value ?? [];
      state = AsyncValue.data(
        currentstate.where((element) => element.catigory == category).toList(),
      );
    }
  }

  Future<void> deleteItem(String id) async {
    final result = await deleteitemUsecase.deleteItem(id);
    result.fold(
      ifLeft: (value) {
        Fluttertoast.showToast(
          msg: "Failed to delete item",
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

  void isDone(String id) async {
    final result = await isDoneUseCase.isDone(id);

    result.fold(
      ifLeft: (value) {
        final current = state.value ?? [];

        state = AsyncValue.data(current);
      },
      ifRight: (value) {
        final current = state.value ?? [];
          state = AsyncValue.data(
            current.map((element) {
              if (element.id == id) {
                return element.copyWith(isDone: !element.isDone);
              }
              return element;
            }).toList(),
        );
      },
    );
  }
}

final todolistNotifierProvider =
    StateNotifierProvider<TodolistNotifire, AsyncValue<List<Todo>>>(
      (ref) => TodolistNotifire(
        addItemUseCase: ref.read(addItemUsecaseProvider),
        deleteitemUsecase: ref.read(deleteItemUsecaseProvider),
        isDoneUseCase: ref.read(isDoneUsecaseProvider),
        loaddataUsecase: ref.read(loadDataUsecaseProvider),
      ),
    );

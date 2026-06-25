import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:todo_app/core/notification/notificationservice.dart';

import 'package:todo_app/feature/home/data/datasource/home_datasource.dart';
import 'package:todo_app/feature/home/data/repository/home_repo.dart';
import 'package:todo_app/feature/home/domain/usecase/additem_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/addnewcategory_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/deletecategory_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/deleteitem_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/getcategory_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/isdone_usecase.dart';
import 'package:todo_app/feature/home/domain/usecase/loaddata_usecase.dart';

final baseHomeDateSourceProvider = Provider((ref) => HomeDatasource());
final homeRepoProvider = Provider(
  (ref) => HomeRepo(dataSource: ref.read(baseHomeDateSourceProvider)),
);

final flitterlocatNotificationProvider = Provider((ref) {
return Notificationservice();
} 
);
//////usecase
final getCategoryUsecaseProvider = Provider(
  (ref) => GetCategoryUsecase(repo: ref.read(homeRepoProvider)),
);
final addNewCategoryUsecaseProvider = Provider(
  (ref) => AddNewCategoryUsecase(repo: ref.read(homeRepoProvider)),
);
final deleteCategoryUsecaseProvider = Provider(
  (ref) => DeleteCategoryUsecase(repo: ref.read(homeRepoProvider)),
);
final loadDataUsecaseProvider = Provider(
  (ref) => LoaddataUsecase(repo: ref.read(homeRepoProvider)),
);
final addItemUsecaseProvider = Provider(
  (ref) => Additemusecase(repo: ref.read(homeRepoProvider)),
);
final deleteItemUsecaseProvider = Provider(
  (ref) => DeleteitemUsecase(repo: ref.read(homeRepoProvider)),
);
final isDoneUsecaseProvider = Provider(
  (ref) => IsdoneUsecase(repo: ref.read(homeRepoProvider)),
);

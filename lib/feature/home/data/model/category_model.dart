import 'package:todo_app/feature/home/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({required super.id, required super.title});
  factory CategoryModel.fromMap(Map<String, Object?> data) {
    return CategoryModel(
      id: data["id"] as String,
      title: data["Title"] as String,
    );
  }
  Map<String, Object?> toMap() {
    return {"id": id, "Title": title};
  }
}

import 'package:envanter_kontrol/model/category.dart';

import '../model/project_firestore.dart';

class CategoryVieModel {
  Future<void> addNewCategory({required ProductCategory category}) async {
    ProjectFirestore db = ProjectFirestore();

    Map<String, dynamic> document = category.toJson();

    db.addDocument(collectionPath: "categories/", document: document);
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    ProjectFirestore db = ProjectFirestore();
    List<Map<String, dynamic>> categoryList =
        await db.readAllDocumentsWithOrder(
            collectionPath: "/categories/",
            orderField: "timestamp",
            isDescending: true);
    print("Kategori Listesi $categoryList");
    return categoryList;
  }
}

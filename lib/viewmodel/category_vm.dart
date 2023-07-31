import 'package:envanter_kontrol/model/category.dart';

import '../model/project_firestore.dart';

class CategoryViewModel {
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

  Future<bool> deleteCategory({required String categoryID}) async {
    try {
      ProjectFirestore db = ProjectFirestore();
      db.deleteDocument(path: "categories/", docID: categoryID);
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}

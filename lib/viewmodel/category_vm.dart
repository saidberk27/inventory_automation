import '../model/project_firestore.dart';

class CategoryVieModel {
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

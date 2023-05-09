import 'package:envanter_kontrol/model/product.dart';
import 'package:envanter_kontrol/model/project_firestore.dart';

class ProductViewModel {
  Future<void> addNewProduct({required Product product}) async {
    ProjectFirestore db = ProjectFirestore();
    print("view modelin içi");
    Map<String, dynamic> document = product.toJson();

    db.addDocument(collectionPath: "products/", document: document);
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    ProjectFirestore db = ProjectFirestore();
    List<Map<String, dynamic>> productList = await db.readAllDocumentsWithOrder(
        collectionPath: "/products/",
        orderField: "timestamp",
        isDescending: true);

    return productList;
  }
}

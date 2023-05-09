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

  void updateStockInfo(
      {required String docID, required String newStock}) async {
    //int InewStock = int.parse(newStock);
    ProjectFirestore db = ProjectFirestore();
    int newStockFinal = int.parse(newStock);
    db.updateDocument(
        path: "products", docID: docID, newData: {"stockCount": newStockFinal});
  }

  void deleteProduct({required String docID}) {
    ProjectFirestore db = ProjectFirestore();
    db.deleteDocument(path: "products/", docID: docID);
  }

  void updateProductInfo(
      {required String docID,
      required String productTitle,
      required String productDescrption}) async {
    Map<String, dynamic> newProductInfo = {};

    if (productTitle == "" && productDescrption != "") {
      newProductInfo = {"description": productDescrption};
    } else if (productTitle != "" && productDescrption == "") {
      newProductInfo = {"title": productTitle};
    } else {
      newProductInfo = {
        "title": productTitle,
        "description": productDescrption
      };
    }
    ProjectFirestore db = ProjectFirestore();

    db.updateDocument(path: "products", docID: docID, newData: newProductInfo);
  }
}

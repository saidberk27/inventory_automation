import 'package:envanter_kontrol/model/product.dart';
import 'package:envanter_kontrol/model/project_firestore.dart';
import 'package:envanter_kontrol/model/project_storage.dart';
import 'package:file_picker/file_picker.dart';

class ProductViewModel {
  Future<String> getMediaURL({required FilePickerResult result}) async {
    ProjectStorage storage = ProjectStorage();
    String url = await storage.uploadMedia(result);
    return url;
  }

  Future<void> addNewProduct(
      {required Product product,
      required String categoryID,
      String? subCategoryID}) async {
    ProjectFirestore db = ProjectFirestore();

    Map<String, dynamic> document = product.toJson();
    if (subCategoryID == null) {
      db.addDocument(
          collectionPath: "categories/$categoryID/products",
          document: document); //TODO Kategori Düzenle}
    } else {
      db.addDocument(
          collectionPath:
              "categories/$categoryID/subcategories/$subCategoryID/products",
          document: document); //TODO Kategori Düzenle}
    }
  }

  /*Future<List<Map<String, dynamic>>> getAllProducts() async {
    ProjectFirestore db = ProjectFirestore();
    List<Map<String, dynamic>> productList = await db.readAllDocumentsWithOrder(
        collectionPath: "/categories/$categoryID/products/",
        orderField: "timestamp",
        isDescending: true);

    return productList;
  }*/

  Future<List<Map<String, dynamic>>> getAllItemsOfCategory(
      {required String categoryID,
      required String itemType,
      required String orderField,
      String? subCategory}) async {
    List<Map<String, dynamic>> productList;
    ProjectFirestore db = ProjectFirestore();
    if (subCategory == null) {
      productList = await db.readAllDocumentsWithOrder(
          collectionPath: "/categories/$categoryID/$itemType",
          orderField: orderField,
          isDescending: true);
    } else {
      productList = await db.readAllDocumentsWithOrder(
          collectionPath:
              "/categories/$categoryID/subcategories/$subCategory/products",
          orderField: orderField,
          isDescending: true);
    }

    return productList;
  }

  Future<bool> updateStockInfo(
      {required String categoryID,
      required String docID,
      required String newStock}) async {
    try {
      //int InewStock = int.parse(newStock);
      ProjectFirestore db = ProjectFirestore();
      int newStockFinal = int.parse(newStock);
      db.updateDocument(
          path: "categories/$categoryID/products",
          docID: docID,
          newData: {"stockCount": newStockFinal});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(
      {required String categoryID, required String docID}) async {
    try {
      ProjectFirestore db = ProjectFirestore();
      db.deleteDocument(path: "categories/$categoryID/products/", docID: docID);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProductInfo(
      {required String categoryID,
      required String docID,
      required String productTitle,
      required String productDescrption}) async {
    try {
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

      db.updateDocument(
          path: "categories/$categoryID/products",
          docID: docID,
          newData: newProductInfo);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchProduct(
      {required String categoryID, required String productName}) async {
    ProjectFirestore db = ProjectFirestore();
    List<Map<String, dynamic>> productList =
        await db.readAllDocumentsWithSearch(
            collectionPath: "/categories/$categoryID/products",
            isDescending: true,
            searchField: "title",
            searchValue: productName,
            orderField: "timestamp");

    return productList;
  }
}

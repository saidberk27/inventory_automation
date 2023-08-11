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
          document: document);
    } else {
      db.addDocument(
          collectionPath:
              "categories/$categoryID/subcategories/$subCategoryID/products",
          document: document);
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
      required String newStock,
      String? subcategoryID}) async {
    try {
      late String path;
      subcategoryID == null
          ? path = "categories/$categoryID/products"
          : path =
              "categories/$categoryID/subcategories/$subcategoryID/products";
      ProjectFirestore db = ProjectFirestore();
      int newStockFinal = int.parse(newStock);
      db.updateDocument(
          path: path, docID: docID, newData: {"stockCount": newStockFinal});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(
      {required String categoryID,
      required String docID,
      String? subcategoryID}) async {
    try {
      late String path;
      subcategoryID == null
          ? path = "categories/$categoryID/products"
          : path =
              "categories/$categoryID/subcategories/$subcategoryID/products";
      ProjectFirestore db = ProjectFirestore();
      db.deleteDocument(path: path, docID: docID);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProductInfo(
      {required String categoryID,
      String? subcategoryID,
      required String docID,
      required String productTitle,
      required String productDescrption,
      required int? tagPrice,
      required int? retailPrice,
      required int? buyPrice}) async {
    try {
      Map<String, dynamic> newProductInfo = {};
      late String path;
      subcategoryID == null
          ? path = "categories/$categoryID/products"
          : path =
              "categories/$categoryID/subcategories/$subcategoryID/products";
      productTitle == ""
          ? newProductInfo.addAll({})
          : newProductInfo.addAll({"title": productTitle});

      productDescrption == ""
          ? newProductInfo.addAll({})
          : newProductInfo.addAll({"description": productDescrption});

      tagPrice == "" || tagPrice == null
          ? newProductInfo.addAll({})
          : newProductInfo.addAll({"tagPrice": tagPrice});

      retailPrice == "" || retailPrice == null
          ? newProductInfo.addAll({})
          : newProductInfo.addAll({"retailPrice": retailPrice});

      buyPrice == "" || buyPrice == null
          ? newProductInfo.addAll({})
          : newProductInfo.addAll({"buyPrice": buyPrice});

      ProjectFirestore db = ProjectFirestore();
      print("burada $newProductInfo");
      db.updateDocument(path: path, docID: docID, newData: newProductInfo);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchProduct(
      {required String categoryID,
      required String productName,
      String? subCategoryID}) async {
    ProjectFirestore db = ProjectFirestore();
    late String collectionPath;
    subCategoryID == null
        ? collectionPath = "/categories/$categoryID/products"
        : collectionPath =
            "/categories/$categoryID/subcategories/$subCategoryID/products";
    List<Map<String, dynamic>> productList =
        await db.readAllDocumentsWithSearch(
            collectionPath: collectionPath,
            isDescending: true,
            searchField: "title",
            searchValue: productName,
            orderField: "timestamp");

    return productList;
  }
}

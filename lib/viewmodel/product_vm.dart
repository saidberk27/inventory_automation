import 'package:envanter_kontrol/model/product.dart';
import 'package:envanter_kontrol/model/project_firestore.dart';
import 'package:envanter_kontrol/model/project_storage.dart';
import 'package:envanter_kontrol/viewmodel/category_vm.dart';
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
    List<Map<String, dynamic>> productList = [];
    List<Map<String, dynamic>> subCategoryProductsList = [];

    List<Map<String, dynamic>> subcategoriesList;
    List<String> subCategoriesIDList;

    CategoryViewModel categoryViewModel = CategoryViewModel();
    subcategoriesList = await categoryViewModel.getAllSubCategoriesOfCategory(
        categoryID: categoryID);
    ProjectFirestore db = ProjectFirestore();
    subCategoriesIDList =
        subcategoriesList.map((sub) => sub['id'] as String).toList();

    for (String subID in subCategoriesIDList) {
      List<Map<String, dynamic>> tempList = await db.readAllDocumentsWithOrder(
          collectionPath:
              "/categories/$categoryID/subcategories/$subID/products",
          orderField: orderField,
          isDescending: true);

      subCategoryProductsList.addAll(tempList);
    }

    if (subCategory == null) {
      if (itemType == "subcategories") {
        productList = await db.readAllDocumentsWithOrder(
            collectionPath: "/categories/$categoryID/$itemType",
            orderField: orderField,
            isDescending: true);
      } else if (itemType == "products") {
        List<Map<String, dynamic>> categoryProducts =
            await db.readAllDocumentsWithOrder(
                collectionPath: "/categories/$categoryID/$itemType",
                orderField: orderField,
                isDescending: true);
        productList.addAll(subCategoryProductsList);
        productList.addAll(categoryProducts);
      }
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

  Future<bool> updateImage(
      {required String categoryID,
      required String docID,
      required String mediaURL,
      String? subcategoryID}) async {
    try {
      late String path;
      subcategoryID == null
          ? path = "categories/$categoryID/products"
          : path =
              "categories/$categoryID/subcategories/$subcategoryID/products";
      ProjectFirestore db = ProjectFirestore();

      db.updateDocument(
          path: path, docID: docID, newData: {"mediaURL": mediaURL});
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
    List<Map<String, dynamic>> productList = [];
    List<String> subCategoriesIDList;
    List<Map<String, dynamic>> subCategoryProductsList = [];
    ProjectFirestore db = ProjectFirestore();
    CategoryViewModel categoryViewModel = CategoryViewModel();
    late String collectionPath;

    if (subCategoryID == null) {
      List<Map<String, dynamic>> subcategoriesList = await categoryViewModel
          .getAllSubCategoriesOfCategory(categoryID: categoryID);

      subCategoriesIDList =
          subcategoriesList.map((sub) => sub['id'] as String).toList();

      for (subCategoryID in subCategoriesIDList) {
        collectionPath =
            "/categories/$categoryID/subcategories/$subCategoryID/products";

        List<Map<String, dynamic>> tempList =
            await db.readAllDocumentsWithSearch(
                collectionPath: collectionPath,
                isDescending: true,
                searchField: "title",
                searchValue: productName,
                orderField: "timestamp");

        subCategoryProductsList.addAll(tempList);
      }

      List<Map<String, dynamic>> categoryProductsList =
          await db.readAllDocumentsWithSearch(
              collectionPath: collectionPath,
              isDescending: true,
              searchField: "title",
              searchValue: productName,
              orderField: "timestamp");

      productList.addAll(categoryProductsList);
      productList.addAll(subCategoryProductsList);
    } else {
      // Search Functionality in SubCategory Details page
      productList = await db.readAllDocumentsWithSearch(
          collectionPath:
              "/categories/$categoryID/subcategories/$subCategoryID/products",
          isDescending: true,
          searchField: "title",
          searchValue: productName,
          orderField: "timestamp");
    }

    return productList;
  }
}

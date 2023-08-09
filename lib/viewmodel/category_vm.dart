import 'package:envanter_kontrol/model/category.dart';
import 'package:flutter/material.dart';
import '../model/project_firestore.dart';

class CategoryViewModel {
  Future<void> addNewCategory(
      {String? categoryPath, required ProductCategory category}) async {
    ProjectFirestore db = ProjectFirestore();

    Map<String, dynamic> document = category.toJson();
    if (categoryPath == null) {
      db.addDocument(collectionPath: "categories/", document: document);
    } else {
      db.addDocument(collectionPath: categoryPath, document: document);
    }
  }

  Future<List<Map<String, dynamic>>> getAllCategories() async {
    ProjectFirestore db = ProjectFirestore();
    List<Map<String, dynamic>> categoryList =
        await db.readAllDocumentsWithOrder(
            collectionPath: "/categories/",
            orderField: "timestamp",
            isDescending: true);
    debugPrint("Kategori Listesi $categoryList");
    return categoryList;
  }

  Future<bool> deleteCategory(
      {required String categoryID, String? subCategoryID}) async {
    try {
      ProjectFirestore db = ProjectFirestore();
      if (subCategoryID == null) {
        db.deleteDocument(path: "categories/", docID: categoryID);
      } else {
        db.deleteDocument(
            path: "categories/$categoryID/subcategories/",
            docID: subCategoryID);
      }
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }

  Future<bool> updateCategoryInfo(
      {required String categoryID,
      required String categoryTitle,
      required String categoryDesc,
      String? subCategoryID}) async {
    try {
      Map<String, dynamic> newCategoryInfo = {};

      if (categoryTitle == "" && categoryDesc != "") {
        newCategoryInfo = {"description": categoryDesc};
      } else if (categoryTitle != "" && categoryDesc == "") {
        newCategoryInfo = {"title": categoryTitle};
      } else {
        newCategoryInfo = {"title": categoryTitle, "description": categoryDesc};
      }
      ProjectFirestore db = ProjectFirestore();

      if (subCategoryID == null) {
        db.updateDocument(
            path: "categories/", docID: categoryID, newData: newCategoryInfo);
      } else {
        db.updateDocument(
            path: "categories/$categoryID/subcategories/",
            docID: subCategoryID,
            newData: newCategoryInfo);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}

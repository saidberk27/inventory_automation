import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProjectFirestore {
  late FirebaseFirestore db;

  ProjectFirestore() {
    db = FirebaseFirestore.instance;
  }

  Future<void> addDocument(
      {required String collectionPath,
      required Map<String, dynamic> document}) async {
    document.addAll({"timestamp": Timestamp.fromDate(DateTime.now())});
    db.collection(collectionPath).add(document).then((documentSnapshot) =>
        debugPrint("Added Data with ID: ${documentSnapshot.id}"));
  }

  Future<void> updateDocument(
      {required String path,
      required String docID,
      required Map<String, dynamic> newData}) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection(path).doc(docID);
    docRef
        .update(newData)
        .then((value) => debugPrint('Document updated'))
        .catchError((error) => debugPrint('Failed to update document: $error'));
  }

  Future<void> deleteDocument(
      {required String path, required String docID}) async {
    db.collection(path).doc(docID).delete().then(
          (doc) => debugPrint("Document deleted"),
          onError: (e) => debugPrint("Error updating document $e"),
        );
  }

  Future<Map<String, dynamic>> readSingleDocument(
      {required String path, required String docID}) async {
    final docRef = db.collection(path).doc(docID);
    Map<String, dynamic> data = {};
    docRef.get().then(
      (DocumentSnapshot doc) {
        data = doc.data() as Map<String, dynamic>;
      },
      onError: (e) => debugPrint("Error getting document: $e"),
    );
    return data;
  }

  Future<List<Map<String, dynamic>>> readAllDocuments(
      {required String collectionPath}) async {
    List<Map<String, dynamic>> documentMaps = [];
    await db.collection(collectionPath).get().then(
      (querySnapshot) {
        debugPrint("Successfully completed");
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> documentMap = docSnapshot.data();
          documentMap.addAll({"id": docSnapshot.id});
          documentMaps.add(documentMap);
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    return documentMaps;
  }

  Future<List<Map<String, dynamic>>> readAllDocumentsWithOrder(
      {required String collectionPath,
      required bool isDescending,
      required String orderField}) async {
    List<Map<String, dynamic>> documentMaps = [];
    await db
        .collection(collectionPath)
        .orderBy(orderField, descending: isDescending)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> documentMap = docSnapshot.data();
          documentMap.addAll({"id": docSnapshot.id});
          documentMaps.add(documentMap);
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    return documentMaps;
  }

  Future<List<Map<String, dynamic>>> readAllDocumentsWithSearch(
      {required String collectionPath,
      required bool isDescending,
      required String searchField,
      required String searchValue,
      required String orderField}) async {
    List<Map<String, dynamic>> documentMaps = [];
    await db
        .collection(collectionPath)
        .where(searchField, isEqualTo: searchValue)
        .orderBy(orderField, descending: isDescending)
        .get()
        .then(
      (querySnapshot) {
        for (var docSnapshot in querySnapshot.docs) {
          Map<String, dynamic> documentMap = docSnapshot.data();
          documentMap.addAll({"id": docSnapshot.id});
          documentMaps.add(documentMap);
          //print('${docSnapshot.id} => ${docSnapshot.data()}');
        }
      },
      onError: (e) => debugPrint("Error completing: $e"),
    );
    return documentMaps;
  }

  Future<void> deleteCollection(String collectionPath) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection(collectionPath);

    // Get all documents in the collection
    QuerySnapshot querySnapshot = await collectionRef.get();

    // Delete each document in the collection
    for (DocumentSnapshot docSnapshot in querySnapshot.docs) {
      await docSnapshot.reference.delete();
    }

    // Delete the collection itself
    await collectionRef
        .doc()
        .delete(); // Since there are no documents left, this will delete the collection
  }
}

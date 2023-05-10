import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart';

class ProjectStorage {
  Future<String> uploadMedia(FilePickerResult result) async {
    final storageRef = FirebaseStorage.instance.ref();
    Uint8List? uploadfile = result.files.single.bytes;

    String filename = basename(result.files.single.name);
    String dirPath = "/";
    final fileRef = storageRef.child("$dirPath$filename");

    try {
      await fileRef.putData(uploadfile!);
      return fileRef.getDownloadURL();
    } catch (e) {
      print(e);
      return e.toString();
    }
  }
}

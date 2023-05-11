import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'fireStorage_base.dart';

class FirebaseStorageService implements StorageBase {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  Reference? _storageReferance;

  @override
  Future<String> uploadFile(
      String userID, String fileType, File uploadFile) async {
    try {
      _storageReferance = _firebaseStorage.ref().child(userID).child(fileType);
      UploadTask uploadTask = _storageReferance!.putFile(uploadFile);
      var url;
      await uploadTask.whenComplete(() async {
        url = await _storageReferance!.getDownloadURL();
      });
      return url;
    } catch (e) {
      debugPrint(e.toString());
      return '';
    }
  }
}

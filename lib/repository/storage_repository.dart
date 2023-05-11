import 'dart:io';

import 'package:avukapp/service/fireStorage_base.dart';

import '../lacator.dart';
import '../service/firestorage_service.dart';

class StorageRepository implements StorageBase {
  final FirebaseStorageService firebaseStorageService =
      getIt<FirebaseStorageService>();

  @override
  Future<String> uploadFile(
      String userID, String fileType, File uploadFile) async {
    return await FirebaseStorageService()
        .uploadFile(userID, fileType, uploadFile);
  }
}

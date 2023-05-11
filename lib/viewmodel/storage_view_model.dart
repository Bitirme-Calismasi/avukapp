
import 'dart:io';

import 'package:avukapp/repository/storage_repository.dart';
import 'package:avukapp/service/fireStorage_base.dart';
import 'package:flutter/material.dart';

import '../lacator.dart';

class StorageViewModel extends ChangeNotifier implements StorageBase {
    final StorageRepository _storageRepository = getIt<StorageRepository>();

  @override
  Future<String> uploadFile(String userID, String fileType, File uploadFile)async {
     var url = await _storageRepository.uploadFile(userID, fileType, uploadFile);
    return url;
  }
  
}
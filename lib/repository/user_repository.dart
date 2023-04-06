import 'package:avukapp/lacator.dart';
import 'package:avukapp/model/user.dart';
import 'package:avukapp/service/auth_base.dart';
import 'package:avukapp/service/firebase_auth_service.dart';
import 'package:avukapp/service/firestore_db.dart';
import 'package:flutter/material.dart';

class UserRepository implements AuthBase {
  final FireBaseAuthService fireBaseAuthService = getIt<FireBaseAuthService>();
  final FirestoreDbService firestoreDbService = getIt<FirestoreDbService>();

  @override
  Future<UserModel> createWithUserEmailAndPass(
      String email, String pass,String userName) async {
    try {
      UserModel user = await fireBaseAuthService.createWithUserEmailAndPass(
          email, pass,userName);
      user.userName = userName;
      await firestoreDbService.saveUser(user); // veritabanı kayıt yapan
      return user;
    } catch (e) {
      debugPrint(
          'USER_REPOSİTORY EMAİL İLE KAYIT OLMA HATA CIKTI ${e.toString()}');
      return UserModel(userID: null, email: null, userName: null);
    }
  }

  @override
  Future<UserModel> currentUser() async {
    UserModel user = await fireBaseAuthService.currentUser();
    return user;
  }

  @override
  Future<UserModel> singInWithEmailAndPass(String email, String pass) async {
    UserModel user =
        await fireBaseAuthService.singInWithEmailAndPass(email, pass);
    return user;
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    UserModel user = await fireBaseAuthService.singInWithGoogle();
    return user;
  }

  @override
  Future<bool> singOut() {
    return fireBaseAuthService.singOut();
  }
}

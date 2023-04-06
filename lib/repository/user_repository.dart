

import 'package:avukapp/lacator.dart';
import 'package:avukapp/model/lawyer.dart';
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
      String email, String pass, String userName) async {
    try {
      UserModel user = await fireBaseAuthService.createWithUserEmailAndPass(
          email, pass, userName);
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
    return await firestoreDbService.readUser(user.userID!);
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

  @override
  Future<UserModel> createWithLawyerAndUserEmailAndPass(
      String email, String pass, String userName, String baroNumber) async {
    try {
      UserModel user =
          await fireBaseAuthService.createWithLawyerAndUserEmailAndPass(
              email, pass, userName, baroNumber);
      user.userName = userName;
      user.isLawyer = 1;
      await firestoreDbService.saveUser(user);
      await firestoreDbService.saveLawyer(LawyerModel(
          lawyerID: user.userID!,
          email: user.email!,
          lawyerBaroNumber: baroNumber,
          userName: user.userName));
      return user;
    } catch (e) {
      debugPrint(
          'USER REPOSİTORY createWithLawyerAndUserEmailAndPass HATA:${e.toString()} ');
      return UserModel(userID: null, email: null, userName: null);
    }
  }
}

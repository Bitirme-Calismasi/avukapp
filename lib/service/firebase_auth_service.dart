import 'package:avukapp/model/user.dart';
import 'package:avukapp/service/auth_base.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FireBaseAuthService implements AuthBase {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Future<UserModel> createWithUserEmailAndPass(
      // NORMAL KULLANICI KAYIT OLMASI İÇİN

      String email,
      String pass,
      String userName) async {
    final user = UserModel(userID: null, email: null, userName: null);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      return _userModelFromFirebase(userCredential.user);
    } catch (e) {
      debugPrint(
          'FİREBASE_AUTH_SERVİCES EMAİL İLE KAYIT OLMA HATA ÇIKTI ${e.toString()}');
      return user;
    }
  }

  @override
  Future<UserModel> currentUser() async {
    // O ANKİ OTURUM AÇMIŞ KULLANICI BİLGİSİNİ BİZE VERİR (KULLANICI OTURM KAPATMADIGI SÜRECE ACIKDIR)
    try {
      debugPrint(' FİREBASEAUTH SERVİS OTURUM AÇAN USER-LAWYER  ${user!.uid} ');
      return _userModelFromFirebase(user);
    } catch (e) {
      debugPrint('hata cıktı currentuser ${e.toString()}');
      return UserModel(userID: null, email: null, userName: null);
    }
  }

  @override
  Future<UserModel> singInWithEmailAndPass(String email, String pass) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: pass);
    return _userModelFromFirebase(userCredential.user);
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return _userModelFromFirebase(userCredential.user);
    } catch (e) {
      debugPrint(
          'google oturum acma işlemi hata çıktı firebase_auth_service${e.toString()}');
      return UserModel(userID: null, email: null, userName: null);
    }
  }

  @override
  Future<bool> singOut() async {
    // OTURUM KAPATMAK İÇİN KULLANILIR
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      debugPrint('singOut hata ${e.toString()}');
      return false;
    }
  }

  @override
  Future<UserModel> createWithLawyerAndUserEmailAndPass(
      String email, String pass, String userName, String baroNUmber) async {
    final user = UserModel(userID: null, email: null, userName: null);
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: pass);
      return _userModelFromFirebase(userCredential.user);
    } catch (e) {
      debugPrint(
          'FİREBASE_AUTH_SERVİCES AVUKAT-USER EMAİL İLE KAYIT OLMA HATA ÇIKTI ${e.toString()}');
      return user;
    }
  }

  @override
  Future<bool> changeEmailAuthPass(String oldPass, String newPass) async {
    bool temp = false;
    final cred =
        EmailAuthProvider.credential(email: user!.email!, password: oldPass);
    await user!.reauthenticateWithCredential(cred).then((value) async {
      await user!.updatePassword(newPass).then((_) {
        temp = true;
      }).catchError((error) {
        temp = false;
      });
    }).catchError((err) {
      temp = false;
    });
    return temp;
  }
}

UserModel _userModelFromFirebase(User? user) {
  // FİREBASE DEN GELEN USER BİZİM MODELİMİZE DÖNÜŞTÜRÜR
  if (user == null) {
    return UserModel(userID: null, email: null, userName: null);
  }
  return UserModel(userID: user.uid, email: user.email, userName: null);
}

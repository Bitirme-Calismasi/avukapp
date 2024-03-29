
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String? userID;
  String? email;
  String? userName;
  String? profilImgURL;
  DateTime? createAt;
  DateTime? updateAt;
  int? isLawyer;

  UserModel(
      {required this.userID, required this.email, required this.userName});

  Map<String, dynamic> ToMap() {
    return {
      'userID': userID,
      'email': email ?? userID,
      'userName': userName ??
          email!.substring(0, email?.indexOf('@')) + randomsayiuret(),
      'profilImgURL': profilImgURL ??
          'https://st.depositphotos.com/1779253/5140/v/950/depositphotos_51405259-stock-illustration-male-avatar-profile-picture-use.jpg',
      'createAt': createAt ?? FieldValue.serverTimestamp(),
      'updateAt': updateAt ?? FieldValue.serverTimestamp(),
      'isLawyer': isLawyer ?? 0, //    varsayılan kullanıcı türü
    };
  }

  UserModel.fromMap(Map<dynamic, dynamic> map)
      : userID = map['userID'],
        email = map['email'],
        userName = map['userName'],
        profilImgURL = map['profilImgURL'],
        createAt = (map['createAt'] as Timestamp).toDate(),
        updateAt = (map['updateAt'] as Timestamp).toDate(),
        isLawyer = map['isLawyer'];

  String toString() {
    return 'users email :$email users nick name: $userName  users profilurl: $profilImgURL users oluşturma tarih $createAt';
  }

  String randomsayiuret() {
    if (email != null) {
      int rastgele = Random().nextInt(99999999);
      return rastgele.toString();
    } else {
      return '';
    }
  }
}

import 'package:avukapp/model/appointment.dart';
import 'package:avukapp/model/declare.dart';
import 'package:avukapp/model/fav_declare.dart';
import 'package:avukapp/model/lawyer.dart';
import 'package:avukapp/model/user.dart';
import 'package:avukapp/service/db_base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

class FirestoreDbService implements DBBase {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<List<UserModel>> getAllUser() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('users').get();
    List<UserModel> allUser = [];
    for (DocumentSnapshot user in querySnapshot.docs) {
      UserModel tekUser = UserModel.fromMap(user.data() as Map);
      allUser.add(tekUser);
    }
    return allUser;
  }

  @override
  Future<UserModel> readUser(String userID) async {
    DocumentSnapshot okunanUser =
        await firebaseFirestore.collection('users').doc(userID).get();
    UserModel user = UserModel.fromMap(okunanUser.data() as Map);
    return user;
  }

  @override
  Future<bool> saveUser(UserModel user) async {
    await firebaseFirestore
        .collection('users')
        .doc(user.userID)
        .set(user.ToMap());
    DocumentSnapshot readUser =
        await firebaseFirestore.doc("users/${user.userID}").get();
    Map readUserDetalys = readUser.data() as Map;
    UserModel _readUser = UserModel.fromMap(readUserDetalys);
    await notificationToken(user.userID!);
    debugPrint(_readUser.toString());

    return true;
  }

  @override
  Future<bool> saveLawyer(LawyerModel lawyer) async {
    await firebaseFirestore
        .collection('lawyers')
        .doc(lawyer.lawyerID)
        .set(lawyer.toMap());
    DocumentSnapshot readLawyer =
        await firebaseFirestore.doc("lawyer/${lawyer.lawyerID}").get();

    return true;
  }

  Future<LawyerModel> readLawyer(String lawyerID) async {
    DocumentSnapshot readLawyer =
        await firebaseFirestore.collection('lawyers').doc(lawyerID).get();
    debugPrint(readLawyer.data().toString());
    LawyerModel lawyer = LawyerModel.fromMap(readLawyer.data() as Map);
    return lawyer;
  }

  Future<List<LawyerModel>> getAllLawyer() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('lawyers').get();
    List<LawyerModel> alllawyer = [];
    for (DocumentSnapshot lawyer in querySnapshot.docs) {
      LawyerModel oneLawyer = LawyerModel.fromMap(lawyer.data() as Map);
      alllawyer.add(oneLawyer);
    }
    return alllawyer;
  }

  Future<bool> lawyerActiveControlAdmin(String lawyerID, bool isActive) async {
    if (isActive == true) {
      await firebaseFirestore
          .collection('lawyers')
          .doc(lawyerID)
          .update({'isActive': isActive});
      return true;
    } else {
      await firebaseFirestore
          .collection('lawyers')
          .doc(lawyerID)
          .update({'isActive': isActive});
      return false;
    }
  }

  Future<bool> updateLawyerProfileImageUrl(
      String lawyerID, String imageUrl) async {
    try {
      await firebaseFirestore
          .collection('lawyers')
          .doc(lawyerID)
          .update({"profilImgURL": imageUrl});
      return true;
    } catch (e) {
      print('Error updating lawyer profile image URL: $e');
      return false;
    }
  }

  Future<bool> saveDeclare(DeclareModel declare) async {
    try {
      var _decID = firebaseFirestore.collection('declare').doc().id;
      declare.declareId = _decID;

      await firebaseFirestore
          .collection('declare')
          .doc(declare.declareId)
          .set(declare.toMap());

      DocumentSnapshot readDeclare =
          await firebaseFirestore.doc("declare/${declare.declareId}").get();
      Map readDeclareDetalys = readDeclare.data() as Map;
      DeclareModel _readDeclare = DeclareModel.fromMap(readDeclareDetalys);
      debugPrint(_readDeclare.toString());
    } catch (e) {
      debugPrint('CLOUDFİRE DECLARE  HATA ÇIKTI ${e.toString()} ');
    }
    return true;
  }

  Future<bool> saveAppointment(AppointmentModel appointment) async {
    try {
      var appID = firebaseFirestore.collection('appointment').doc().id;
      appointment.appointmentID = appID;
      await firebaseFirestore
          .collection('appointment')
          .doc(appointment.appointmentID)
          .set(appointment.toMap());
    } catch (e) {
      debugPrint('CLOUDFİRE APPOLİMENTSAVE   HATA ÇIKTI ${e.toString()} ');
    }
    return true;
  }

  Future<AppointmentModel> getAppointmentDate(String appointmentID) async {
    DocumentSnapshot readAppo = await firebaseFirestore
        .collection('appointment')
        .doc(appointmentID)
        .get();
    AppointmentModel appo = AppointmentModel.fromMap(readAppo.data() as Map);
    return appo;
  }

  Future<bool> createMeetingLawyer(
      String appointmentID, String meetingID) async {
    try {
      await firebaseFirestore
          .collection('appointment')
          .doc(appointmentID)
          .update({"meetingID": meetingID});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<AppointmentModel>> getForIdAppointment(String userId) async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('appointment').get();
    List<AppointmentModel> allApo = [];
    for (DocumentSnapshot apo in querySnapshot.docs) {
      AppointmentModel oneApo = AppointmentModel.fromMap(apo.data() as Map);
      if (oneApo.userID == userId) {
        allApo.add(oneApo);
      }
    }
    return allApo;
  }

  Future<List<AppointmentModel>> getForIdLawyerAppointment(
      String lawyerId) async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('appointment').get();
    List<AppointmentModel> allApo = [];
    for (DocumentSnapshot apo in querySnapshot.docs) {
      AppointmentModel oneApo = AppointmentModel.fromMap(apo.data() as Map);
      if (oneApo.lawyerID == lawyerId) {
        allApo.add(oneApo);
      }
    }
    return allApo;
  }

  Future<bool> deleteAppointment(String appointmentID) async {
    DocumentReference temp =
        firebaseFirestore.collection('appointment').doc(appointmentID);
    temp.delete();
    return true;
  }

  Future<bool> confirmAppointmentLawyer(
      String appointmentID, DateTime appointmentDate) async {
    if (appointmentID.isNotEmpty && appointmentDate.toString().isNotEmpty) {
      await firebaseFirestore
          .collection('appointment')
          .doc(appointmentID)
          .update({'appointmentDate': appointmentDate, 'isActive': true});
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateDeclare(
      String declareId,
      String declareTitle,
      String declareContent,
      String declareCategory,
      String declarePrice) async {
    await firebaseFirestore.collection('declare').doc(declareId).update({
      'declareTitle': declareTitle,
      'declareContent': declareContent,
      'declareCategory': declareCategory,
      'declarePrice': declarePrice,
    });
    return true;
  }

  Future<List<DeclareModel>> getAllDeclate() async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('declare').get();
    List<DeclareModel> allDeclare = [];
    for (DocumentSnapshot declare in querySnapshot.docs) {
      DeclareModel oneDeclare = DeclareModel.fromMap(declare.data() as Map);
      allDeclare.add(oneDeclare);
    }
    return allDeclare;
  }

  Future<bool> favoriDeclare(DeclareModel declare, String userID) async {
    var appID = firebaseFirestore.collection('favorideclare').doc().id;
    FavDeclareModel fav = FavDeclareModel(
        declareId: declare.declareId,
        lawyerId: declare.lawyerId,
        declareDate: declare.declareDate,
        declareTitle: declare.declareTitle,
        declareContent: declare.declareContent,
        declareCategory: declare.declareCategory,
        declarePrice: declare.declarePrice,
        lawyerProfilUrl: declare.lawyerProfilUrl,
        isActive: declare.isActive,
        userID: userID);
    await firebaseFirestore
        .collection('favorideclare')
        .doc(appID)
        .set(fav.toMap());
    return true;
  }

  Future<List<FavDeclareModel>> getForFavorieDeclare(String userID) async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('favorideclare').get();
    List<FavDeclareModel> allDeclare = [];
    for (DocumentSnapshot declare in querySnapshot.docs) {
      FavDeclareModel oneDeclare =
          FavDeclareModel.fromMap(declare.data() as Map);
      if (oneDeclare.userID == userID) {
        allDeclare.add(oneDeclare);
      }
    }
    return allDeclare;
  }

  Future<bool> deleteFavDeclare(String declareID) async {
    try {
      DocumentReference temp =
          firebaseFirestore.collection('favorideclare').doc(declareID);
      temp.delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDeclare(String declareId) async {
    DocumentReference temp =
        firebaseFirestore.collection('declare').doc(declareId);
    temp.delete();
    return true;
  }

  @override
  Future<bool> updateUserProfileImageUrl(String userId, String imageUrl) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userId)
          .update({"profilImgURL": imageUrl});
      return true;
    } catch (e) {
      print('Error updating user profile image URL: $e');
      return false;
    }
  }

  Future<List<DeclareModel>> getForIdDeclare(String lawyerId) async {
    QuerySnapshot querySnapshot =
        await firebaseFirestore.collection('declare').get();
    List<DeclareModel> allDeclare = [];
    for (DocumentSnapshot declare in querySnapshot.docs) {
      DeclareModel oneDeclare = DeclareModel.fromMap(declare.data() as Map);
      if (oneDeclare.lawyerId == lawyerId) {
        allDeclare.add(oneDeclare);
      }
    }
    return allDeclare;
  }

  @override
  Future<bool> updateUserName(String userID, String newUserName) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userID)
          .update({"userName": newUserName});
      return true;
    } catch (e) {
      print('Error updating user profile image URL: $e');
      return false;
    }
  }

  @override
  Future<bool> updateEmail(String userID, String newEmail) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(userID)
          .update({"email": newEmail});
      return true;
    } catch (e) {
      print('Error updating user profile image URL: $e');
      return false;
    }
  }

  Future<bool> updateLawyerUserName(String userID, String newUserName) async {
    try {
      await firebaseFirestore
          .collection('lawyers')
          .doc(userID)
          .update({"userName": newUserName});
      return true;
    } catch (e) {
      print('Error updating user profile image URL: $e');
      return false;
    }
  }

  Future<bool> updateLawyerEmail(String userID, String newEmail) async {
    try {
      await firebaseFirestore
          .collection('lawyers')
          .doc(userID)
          .update({"email": newEmail});
      return true;
    } catch (e) {
      print('Error updating user profile image URL: $e');
      return false;
    }
  }

  Future<bool> updateLawyerField(String userID, String newField) async {
    try {
      await firebaseFirestore
          .collection('lawyers')
          .doc(userID)
          .update({"lawyerField": newField});
      return true;
    } catch (e) {
      print('Error updating user profile image URL: $e');
      return false;
    }
  }

  Future<bool> updateExperision(String userID, String newExperision) async {
    try {
      await firebaseFirestore
          .collection('lawyers')
          .doc(userID)
          .update({"lawyerExperience": newExperision});
      return true;
    } catch (e) {
      print('Error updating user profile image URL: $e');
      return false;
    }
  }

  Future<void> notificationToken(String id) async {
    String? token;
    await firebaseMessaging
        .getToken(
            vapidKey:
                'AAAADt3D2S8:APA91bF5OyNQZGbveJ6nMF-NKNEAyafk1CxHtCMYN81W7vRPC8OTaAdesdvbx9T4iyGNutNgW5WoE61poEhcUG4k-De6AkNzBt_CYrl26IuAQtD_nRWCqRGFim8KBXrjippZzMRiSIXD')
        .then((value) {
      token = value;
      debugPrint(token);
    });
    if (token!.isNotEmpty) {
      await firebaseFirestore
          .collection('userToken')
          .doc(id)
          .set({'token': token});
    }
  }

  Future<String> readToken(String id) async {
    debugPrint('OKUNAN id: $id');
    DocumentSnapshot readToken =
        await firebaseFirestore.collection('userToken').doc(id).get();
    String token = readToken.get('token');
    debugPrint('OKUNAN TOKEN: $token');
    return token;
  }
}

import 'dart:convert';

import 'package:avukapp/model/appointment.dart';
import 'package:avukapp/model/declare.dart';
import 'package:avukapp/model/fav_declare.dart';
import 'package:avukapp/service/db_base.dart';
import 'package:flutter/foundation.dart';
import '../lacator.dart';
import '../service/firestore_db.dart';
import 'package:http/http.dart' as http;

class DeclareRepository implements DBBaseDeclare {
  final FirestoreDbService firestoreDbService = getIt<FirestoreDbService>();

  @override
  Future<List<DeclareModel>> getAllDeclare() async {
    return await firestoreDbService.getAllDeclate();
  }

  @override
  Future<bool> saveDeclare(DeclareModel declare) async {
    return await firestoreDbService.saveDeclare(declare);
  }

  @override
  Future<bool> deleteDeclare(String declareId) async {
    return await firestoreDbService.deleteDeclare(declareId);
  }

  @override
  Future<bool> updateDeclare(
      String declareId,
      String declareTitle,
      String declareContent,
      String declareCategory,
      String declarePrice) async {
    return await firestoreDbService.updateDeclare(
        declareId, declareTitle, declareContent, declareCategory, declarePrice);
  }

  @override
  Future<List<DeclareModel>> getForIdDeclare(String lawyerId) async {
    return await firestoreDbService.getForIdDeclare(lawyerId);
  }

  @override
  Future<bool> saveAppointment(AppointmentModel appointment) async {
    bool temp = await firestoreDbService.saveAppointment(appointment);
    if (temp) {
      final user = await firestoreDbService.readUser(appointment.userID!);
      String token = await firestoreDbService.readToken(appointment.lawyerID!);
      String endURL = "https://fcm.googleapis.com/fcm/send";
      String firebaseKey =
          "AAAADt3D2S8:APA91bF5OyNQZGbveJ6nMF-NKNEAyafk1CxHtCMYN81W7vRPC8OTaAdesdvbx9T4iyGNutNgW5WoE61poEhcUG4k-De6AkNzBt_CYrl26IuAQtD_nRWCqRGFim8KBXrjippZzMRiSIXD";

      var data = {
        'to': token,
        'notification': {
          'title': 'Yeni Bir Randevu İstegi',
          'body': '${user.userName} Kullanıcısından',
          "sound": "jetsons_doorbell.mp3"
        },
        'android': {
          'notification': {
            'notification_count': 23,
          },
        },
        'data': {'type': 'msj', 'id': 'Asif Taj'}
      };
      http.Response response =
          await http.post(Uri.parse(endURL), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$firebaseKey'
      });
      if (response.statusCode == 200) {
        debugPrint("AAAAAAAAAAAAAAAAAişlem basarılı");
      } else {
        debugPrint("işlem basarısız:" + response.statusCode.toString());
      }
    }
    return temp;
  }

  @override
  Future<List<AppointmentModel>> getForIdAppointment(String userId) async {
    return await firestoreDbService.getForIdAppointment(userId);
  }

  @override
  Future<List<AppointmentModel>> getForIdLwyerAppointment(
      String lawyerId) async {
    return await firestoreDbService.getForIdLawyerAppointment(lawyerId);
  }

  @override
  Future<bool> confirmAppointmentLawyer(String appointmentID,
      DateTime appointmentDate, AppointmentModel appointment) async {
    bool temp = await firestoreDbService.confirmAppointmentLawyer(
        appointmentID, appointmentDate);
    if (temp) {
      final user = await firestoreDbService.readUser(appointment.lawyerID!);
      String token = await firestoreDbService.readToken(appointment.userID!);
      String endURL = "https://fcm.googleapis.com/fcm/send";
      String firebaseKey =
          "AAAADt3D2S8:APA91bF5OyNQZGbveJ6nMF-NKNEAyafk1CxHtCMYN81W7vRPC8OTaAdesdvbx9T4iyGNutNgW5WoE61poEhcUG4k-De6AkNzBt_CYrl26IuAQtD_nRWCqRGFim8KBXrjippZzMRiSIXD";

      var data = {
        'to': token,
        'notification': {
          'title': 'Randevunuz onaylandı',
          'body': '${user.userName} Tarafından',
          "sound": "jetsons_doorbell.mp3"
        },
        'android': {
          'notification': {
            'notification_count': 23,
          },
        },
        'data': {'type': 'msj', 'id': 'Asif Taj'}
      };
      http.Response response =
          await http.post(Uri.parse(endURL), body: jsonEncode(data), headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'key=$firebaseKey'
      });
      if (response.statusCode == 200) {
        debugPrint("AAAAAAAAAAAAAAAAAişlem basarılı");
      } else {
        debugPrint("işlem basarısız:" + response.statusCode.toString());
      }
    }

    return temp;
  }

  @override
  Future<bool> deleteAppointment(String appointmentID) async {
    return await firestoreDbService.deleteAppointment(appointmentID);
  }

  @override
  Future<AppointmentModel> getAppointmentDate(String appointmentID) async {
    return await firestoreDbService.getAppointmentDate(appointmentID);
  }

  @override
  Future<bool> createMeetingLawyer(
      String appointmentID, String meetingID) async {
    return await firestoreDbService.createMeetingLawyer(
        appointmentID, meetingID);
  }

  @override
  Future<bool> favoriDeclare(DeclareModel declare, String userID) async {
    return await firestoreDbService.favoriDeclare(declare, userID);
  }

  @override
  Future<List<FavDeclareModel>> getForFavorieDeclare(String userID) async {
    return await firestoreDbService.getForFavorieDeclare(userID);
  }

  @override
  Future<bool> deleteFavDeclare(String declareID) async {
    return await firestoreDbService.deleteFavDeclare(declareID);
  }
}

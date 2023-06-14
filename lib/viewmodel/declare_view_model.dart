import 'package:avukapp/model/appointment.dart';
import 'package:avukapp/model/declare.dart';
import 'package:avukapp/model/fav_declare.dart';
import 'package:avukapp/model/lawyer.dart';
import 'package:avukapp/repository/declare_repository.dart';
import 'package:avukapp/service/db_base.dart';
import 'package:flutter/material.dart';
import '../lacator.dart';

class DeclareViewModel extends ChangeNotifier implements DBBaseDeclare {
  final DeclareRepository declareRepository = getIt<DeclareRepository>();

  LawyerModel? _declare;
  LawyerModel? get declare => _declare;

  @override
  Future<List<DeclareModel>> getAllDeclare() async {
    return await declareRepository.getAllDeclare();
  }

  @override
  Future<bool> saveDeclare(DeclareModel declare) async {
    return await declareRepository.saveDeclare(declare);
  }

  @override
  Future<bool> deleteDeclare(String declareId) async {
    return await declareRepository.deleteDeclare(declareId);
  }

  @override
  Future<bool> updateDeclare(
      String declareId,
      String declareTitle,
      String declareContent,
      String declareCategory,
      String declarePrice) async {
    return await declareRepository.updateDeclare(
        declareId, declareTitle, declareContent, declareCategory, declarePrice);
  }

  @override
  Future<List<DeclareModel>> getForIdDeclare(String lawyerId) async {
    return await declareRepository.getForIdDeclare(lawyerId);
  }

  @override
  Future<bool> saveAppointment(AppointmentModel appointment) async {
    return await declareRepository.saveAppointment(appointment);
  }

  @override
  Future<List<AppointmentModel>> getForIdAppointment(String userId) async {
    return await declareRepository.getForIdAppointment(userId);
  }

  @override
  Future<List<AppointmentModel>> getForIdLwyerAppointment(
      String lawyerId) async {
    return await declareRepository.getForIdLwyerAppointment(lawyerId);
  }

  @override
  Future<bool> confirmAppointmentLawyer(String appointmentID,
      DateTime appointmentDate, AppointmentModel appointment) async {
    return await declareRepository.confirmAppointmentLawyer(
        appointmentID, appointmentDate, appointment);
  }

  @override
  Future<bool> deleteAppointment(String appointmentID) async {
    return await declareRepository.deleteAppointment(appointmentID);
  }

  @override
  Future<AppointmentModel> getAppointmentDate(String appointmentID) async {
    return await declareRepository.getAppointmentDate(appointmentID);
  }

  @override
  Future<bool> createMeetingLawyer(
      String appointmentID, String meetingID) async {
    return await declareRepository.createMeetingLawyer(
        appointmentID, meetingID);
  }

  @override
  Future<bool> favoriDeclare(DeclareModel declare, String userID) async {
    return declareRepository.favoriDeclare(declare, userID);
  }

  @override
  Future<List<FavDeclareModel>> getForFavorieDeclare(String userID) async {
    return declareRepository.getForFavorieDeclare(userID);
  }

  @override
  Future<bool> deleteFavDeclare(String declareID) async {
    return declareRepository.deleteFavDeclare(declareID);
  }
}

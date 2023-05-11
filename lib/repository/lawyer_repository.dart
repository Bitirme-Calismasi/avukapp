import 'package:avukapp/service/db_base.dart';
import '../lacator.dart';
import '../model/lawyer.dart';
import '../service/firestore_db.dart';

class LawyerRepository implements DBBaselawyer {
  final FirestoreDbService firestoreDbService = getIt<FirestoreDbService>();

  @override
  Future<List<LawyerModel>> getAllLawyer() async {
    return await firestoreDbService.getAllLawyer();
  }

  @override
  Future<LawyerModel> readLawyer(String lawyerID) async {
    return await firestoreDbService.readLawyer(lawyerID);
  }

  @override
  Future<bool> lawyerActiveControlAdmin(String lawyerID, bool isActive) async {
    return await firestoreDbService.lawyerActiveControlAdmin(
        lawyerID, isActive);
  }

  @override
  Future<bool> updateLawyerProfileImageUrl(
      String lawyerID, String imageUrl) async {
    return await firestoreDbService.updateLawyerProfileImageUrl(
        lawyerID, imageUrl);
  }

  @override
  Future<bool> updateExperision(String userID, String newExperision) async {
    return await firestoreDbService.updateExperision(userID, newExperision);
  }

  @override
  Future<bool> updateLawyerEmail(String userID, String newEmail) async {
    return await firestoreDbService.updateLawyerEmail(userID, newEmail);
  }

  @override
  Future<bool> updateLawyerField(String userID, String newField) async {
    return await firestoreDbService.updateLawyerField(userID, newField);
  }

  @override
  Future<bool> updateLawyerUserName(String userID, String newUserName) async {
    return await firestoreDbService.updateLawyerUserName(userID, newUserName);
  }
}

import 'package:avukapp/model/declare.dart';

import '../model/lawyer.dart';
import '../model/user.dart';

abstract class DBBase {
  Future<bool> saveUser(UserModel user);
  Future<UserModel> readUser(String userID);
  Future<List<UserModel>> getAllUser();
  Future<bool> saveLawyer(LawyerModel lawyer);
  Future<bool> updateUserProfileImageUrl(String userId, String imageUrl);
  Future<bool> updateUserName(String userID, String newUserName);
  Future<bool> updateEmail(String userID, String newEmail);
}

abstract class DBBaselawyer {
  Future<LawyerModel> readLawyer(String lawyerID);
  Future<List<LawyerModel>> getAllLawyer();
  Future<bool> lawyerActiveControlAdmin(String lawyerID, bool isActive);
  Future<bool> updateLawyerProfileImageUrl(String lawyerID, String imageUrl);
   Future<bool> updateLawyerUserName(String userID, String newUserName);
  Future<bool> updateLawyerEmail(String userID, String newEmail);
   Future<bool> updateLawyerField(String userID, String newField);
  Future<bool> updateExperision(String userID, String newExperision);
}

abstract class DBBaseDeclare {
  Future<bool> saveDeclare(DeclareModel declare);
  Future<List<DeclareModel>> getAllDeclare();
  Future<bool> deleteDeclare(String declareId);
  Future<List<DeclareModel>> getForIdDeclare(String lawyerId);
  Future<bool> updateDeclare(String declareId, String declareTitle,
      String declareContent, String declareCategory, String declarePrice);
}

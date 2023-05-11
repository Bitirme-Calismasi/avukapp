import 'package:avukapp/lacator.dart';
import 'package:avukapp/model/user.dart';
import 'package:avukapp/repository/user_repository.dart';
import 'package:avukapp/service/auth_base.dart';
import 'package:flutter/material.dart';

enum ViewState { Idle, Busy }

class UserViewModel extends ChangeNotifier implements AuthBase {
  ViewState _state = ViewState.Idle;
  final UserRepository _userRepository = getIt<UserRepository>();
  UserModel? _user;

  UserModel? get user => _user;
  UserViewModel() {
    currentUser();
  }

  ViewState get state => _state;

  set state(ViewState value) {
    _state = value;
    debugPrint('viewstate tetiklendi');
    notifyListeners();
  }

  @override
  Future<UserModel> currentUser() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.currentUser();
      debugPrint('CURRENT USER USER OKUMA İŞLEMİ OLDU USERVİEWMODEL******');
      return user!;
    } catch (e) {
      debugPrint('viewmodel currentuser da hata cıktı ${e.toString()}');
      return UserModel(userID: null, email: null, userName: null);
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> currentUserRefresh() async {
    _user = await _userRepository.currentUser();
    debugPrint('CURRENT USER USER OKUMA İŞLEMİ OLDU USERVİEWMODEL******');
    return user!;
  }

  @override
  Future<UserModel> readUser(String userID) async {
    return _userRepository.readUser(userID);
  }

  @override
  Future<UserModel> singInWithEmailAndPass(String email, String pass) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInWithEmailAndPass(email, pass);
      debugPrint('USERROPOSİTORY EMAİL İLE KAYIT OLMA TETİKLENDİ');

      return user!;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> createWithUserEmailAndPass(
      String email, String pass, String userName) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.createWithUserEmailAndPass(
          email, pass, userName);
      return _user!;
    } catch (e) {
      debugPrint(
          'EMAİL İLE KAYIT OLMA USERVİEW_MODEL SORUN CIKTI ${e.toString()}');
      return UserModel(userID: null, email: null, userName: null);
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> singInWithGoogle() async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.singInWithGoogle();
      debugPrint('tetiklendi');
      return user!;
    } catch (e) {
      debugPrint('viewmodel googleilegiris  da hata cıktı ${e.toString()}');
      return UserModel(userID: null, email: null, userName: null);
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<bool> singOut() async {
    try {
      state = ViewState.Busy;
      bool temp = await _userRepository.singOut();
      _user = null;
      return temp;
    } catch (e) {
      debugPrint('viewmodel singOut da hata cıktı ${e.toString()}');
      return false;
    } finally {
      state = ViewState.Idle;
    }
  }

  @override
  Future<UserModel> createWithLawyerAndUserEmailAndPass(
      String email, String pass, String userName, String baroNumber) async {
    try {
      state = ViewState.Busy;
      _user = await _userRepository.createWithLawyerAndUserEmailAndPass(
          email, pass, userName, baroNumber);
      return _user!;
    } catch (e) {
      debugPrint(
          'USER VİEW MODEL createWithLawyerAndUserEmailAndPass HATA: ${e.toString()}');
      return UserModel(userID: null, email: null, userName: null);
    } finally {
      state = ViewState.Idle;
    }
  }

  Future<List<UserModel>> getAllUser() async {
    return await _userRepository.getAllUser();
  }

  Future<bool> updateUserProfileImageUrl(String userId, String imageUrl) async {
    bool temp =
        await _userRepository.updateUserProfileImageUrl(userId, imageUrl);
    currentUserRefresh();
    return temp;
  }

  Future<bool> updateEmail(String userID, String newEmail) async {
    bool temp = await _userRepository.updateEmail(userID, newEmail);
    currentUserRefresh();
    return temp;
  }

  Future<bool> updateUserName(String userID, String newUserName) async {
    bool temp = await _userRepository.updateUserName(userID, newUserName);
    currentUserRefresh();
    return temp;
  }

  @override
  Future<bool> changeEmailAuthPass(String oldPass, String newPass) async {
    return await _userRepository.changeEmailAuthPass(oldPass, newPass);
  }
}

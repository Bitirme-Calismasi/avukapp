import 'package:avukapp/repository/declare_repository.dart';
import 'package:avukapp/repository/lawyer_repository.dart';
import 'package:avukapp/repository/storage_repository.dart';
import 'package:avukapp/repository/user_repository.dart';
import 'package:avukapp/service/firebase_auth_service.dart';
import 'package:avukapp/service/firestorage_service.dart';
import 'package:avukapp/service/firestore_db.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton(() => FireBaseAuthService());
  getIt.registerLazySingleton(() => UserRepository());
  getIt.registerLazySingleton(() => FirestoreDbService());
  getIt.registerLazySingleton(() => LawyerRepository());
  getIt.registerLazySingleton(() => DeclareRepository());
  getIt.registerLazySingleton(() => FirebaseStorageService());
  getIt.registerLazySingleton(() => StorageRepository());
}

import 'package:avukapp/constant/constant.dart';
import 'package:avukapp/lacator.dart';
import 'package:avukapp/screens/landing_screen.dart';
import 'package:avukapp/viewmodel/declare_view_model.dart';
import 'package:avukapp/viewmodel/lawyer_view_model.dart';
import 'package:avukapp/viewmodel/storage_view_model.dart';
import 'package:avukapp/viewmodel/user_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<StorageViewModel>(
          create: (context) => StorageViewModel(),
        ),
        ChangeNotifierProvider<UserViewModel>(
          create: (context) => UserViewModel(),
        ),
        ChangeNotifierProvider<LawyerViewModel>(
          create: (context) => LawyerViewModel(),
        ),
        ChangeNotifierProvider<DeclareViewModel>(
          create: (context) => DeclareViewModel(),
        ),
      ],
      child: MaterialApp(
        title: 'Material App',
        debugShowCheckedModeBanner: false,
        color: Colors.white,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          iconTheme: const IconThemeData(
            color: kWineRedColor,
          ),
        ),
        home: LandingPage(),
      ),
    );
  }
}

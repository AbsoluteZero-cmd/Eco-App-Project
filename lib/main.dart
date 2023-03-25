import 'package:camera/camera.dart';
import 'package:eco_app_project/auth/login_register_page.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/navigation.dart';
import 'package:eco_app_project/pages/new_history_item_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eco_app_project/auth/auth.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();

  await Firebase.initializeApp();
  runApp(MyApp(cameras: cameras));
}

class MyApp extends StatelessWidget {
  const MyApp({required this.cameras, Key? key}) : super(key: key);

  final List<CameraDescription> cameras;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        primaryColor: kPrimaryColor,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange).copyWith(secondary: kSecondaryColor),
      ),
      home: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // return Navigation(cameras: cameras);
            return Navigation(cameras: cameras);
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

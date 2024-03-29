import 'package:eco_app_project/auth/login_register_page.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/navigation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:eco_app_project/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        fontFamily: 'Montserrat',
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepOrange)
            .copyWith(secondary: kSecondaryColor),
      ),
      home: StreamBuilder(
        stream: Auth().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Navigation();
          } else {
            return const LoginPage();
          }
        },
      ),
    );
  }
}

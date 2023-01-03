import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final Future<FirebaseApp> _firebaseAuth = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        accentColor: kSecondaryColor
      ),
      home: FutureBuilder(
        future: _firebaseAuth,
        builder: (context, snapshot) {
          if(snapshot.hasError){
            return Text('Something gone wrong');
          }
          else if(snapshot.hasData){
            FirebaseAuth.instance
                .userChanges()
                .listen((User? user) {
              if (user == null) {
                print('User is currently signed out!');
              } else {
                print('User is signed in!');
              }
            });
            return Navigation();
          }
          else{
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
}


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth.dart';

class SettingsPage extends StatelessWidget {
  SettingsPage({Key? key}) : super(key: key);

  final User? currentUser = Auth().currentUser;

  Future<void> signOut() async {
    await Auth().signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            children: [
              Text('settings'),
              Text(currentUser?.email ?? 'User mail'),
              ElevatedButton(
                  onPressed: signOut,
                  child: Text('Sign out')
              )
            ],
          )
      ),
    );
  }
}
import 'package:eco_app_project/auth/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eco_app_project/pages/home_page.dart';
import 'package:flutter/material.dart';

class UserManagement {
  storeNewUser(user, context) async {
    var firebaseUser = Auth().currentUser;
    FirebaseFirestore.instance
        .collection('users').add({'email': firebaseUser?.email})
    .then((value) =>
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => HomePage()))
    );
  }
}
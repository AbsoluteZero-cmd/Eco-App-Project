import 'package:eco_app_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth.dart';
import '../auth/login_register_page.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? currentUser = Auth().currentUser;

  late String username;
  late String email;
  late String phone;

  @override
  initState() {
    super.initState();
    username = currentUser?.displayName ?? 'no name';
    email = currentUser?.email ?? 'no email';
  }

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
    Navigator.pop(context);
  }

  Widget SettingItem(String title, String val, bool isEmail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding * 0.5),
        child: Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "$title:",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Flexible(
                child: TextButton.icon(
                  onPressed: () {
                    _displayTextInputDialog(context, isEmail);
                  },
                  icon: Flexible(
                    child: Text(
                      val,
                      style: TextStyle(color: Colors.black),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  label: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      margin: EdgeInsets.all(kDefaultPadding * 1.2),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Settings',
                style: TextStyle(
                    fontSize: kFontTitle, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(vertical: kDefaultPadding * 0.5),
                child: Text(
                    'You may need to re-authenticate to make changes in your account'),
              )
            ],
          ),
          SettingItem("Username", username, false),
          SettingItem("Email", email, true),
          ElevatedButton(
              onPressed: signOut,
              child: SizedBox(
                  width:
                      MediaQuery.of(context).size.width - 2.4 * kDefaultPadding,
                  child: Center(child: Text('Sign out'))))
        ],
      ),
    ));
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, bool isEmail) async {
    String newValue = '';
    String currentOption = isEmail ? 'email' : 'username';
    String error = '';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Change $currentOption'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Enter new $currentOption',
                errorText: error == '' ? null : error,
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    error = 'The input must not be empty';
                  } else if (value.length > 30) {
                    error = 'The length must be less than 30 symbols';
                  } else {
                    newValue = value;
                  }
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor, backgroundColor: Colors.white),
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    foregroundColor: kPrimaryColor, backgroundColor: Colors.white),
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    if (newValue.isNotEmpty && error == '') {
                      if (isEmail) {
                        setState(() {
                          email = newValue;
                          FirebaseAuth.instance.currentUser?.updateEmail(email);
                        });
                      } else {
                        setState(() {
                          username = newValue;
                          FirebaseAuth.instance.currentUser
                              ?.updateDisplayName(username);
                        });
                      }
                    } else {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text(error)));
                    }
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}

import 'package:eco_app_project/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/auth.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final User? currentUser = Auth().currentUser;

  late String username;
  late String email;
  late String phone;

  @override
  initState(){
    super.initState();
    username = currentUser?.displayName ?? 'no name';
    email = currentUser?.email ?? 'no email';
  }

  Future<void> signOut() async {
    await Auth().signOut();
  }

  Widget SettingItem(String title, String val, bool isEmail){
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(kDefaultPadding * 0.5),
        child: Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title + ":",
                style: TextStyle(
                  fontWeight: FontWeight.w600
                ),
              ),
              Flexible(
                child: Container(
                  child: TextButton.icon(
                    onPressed: () {
                      _displayTextInputDialog(context, isEmail);
                    },
                    icon: Text(
                      '${val}',
                      style: TextStyle(
                          color: Colors.black
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    label: Icon(Icons.edit),
                  ),
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
              children: [
                Text(
                  'Settings',
                  style: TextStyle(
                      fontSize: kFontTitle,
                      fontWeight: FontWeight.bold
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.5),
                  child: Text('You may need to re-authenticate to make changes in your account'),
                )
              ],
            ),
            SettingItem("Username", username, false),
            SettingItem("Email", email, true),
            ElevatedButton(
                onPressed: signOut,
                child: Container(
                    width: MediaQuery.of(context).size.width - 2.4 * kDefaultPadding,
                    child: Center(child: Text('Sign out'))
                )
            )
          ],
        ),
      )
    );
  }

  Future<void> _displayTextInputDialog(BuildContext context, bool isEmail) async {
    String newValue = '';
    String currentOption = isEmail ? 'email' : 'username';
    String _error = '';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(

            title: Text('Change ${currentOption}'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Enter new ${currentOption}',
                errorText: _error == '' ? null : _error,
              ),
              onChanged: (value) {
                setState(() {
                  if(value.isEmpty || value == null){
                    _error = 'The input must not be empty';
                  }
                  else if(value.length > 10){
                    _error = 'The length must be less than 10 symbols';
                  }
                  else{
                    newValue = value;
                  }
                });
              },
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(
                  primary: kPrimaryColor,
                  backgroundColor: Colors.white
                ),
                child: Text('Cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                    primary: kPrimaryColor,
                    backgroundColor: Colors.white
                ),
                child: Text('Ok'),
                onPressed: () {
                  setState(() {
                    if(newValue.isNotEmpty && _error == ''){
                      if(isEmail){
                        setState(() {
                          email = newValue;
                          // currentUser?.updateEmail("janeq@example.com");
                          FirebaseAuth.instance.currentUser?.updateEmail(email);
                        });
                      }
                      else{
                        setState(() {
                          username = newValue;
                          // currentUser?.updateEmail("janeq@example.com");
                          FirebaseAuth.instance.currentUser?.updateDisplayName(username);
                        });
                      }
                    }
                    else{
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_error)));
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

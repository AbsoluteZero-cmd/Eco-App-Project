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
    username = currentUser?.displayName ?? 'Нет имени';
    email = currentUser?.email ?? 'Нет почты';
  }

  Future<void> signOut() async {
    await Auth().signOut();
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginPage()));
    Navigator.pop(context);
  }

  Widget SettingItem(String title, String val, bool isEmail) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                    'Настройки',
                    style: TextStyle(
                        fontSize: kFontTitle, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding:
                    EdgeInsets.symmetric(vertical: kDefaultPadding * 0.5),
                    child: Text(
                        'Возможно вам потребуется перезайти в приложение, чтобы изменения вошли в силу'),
                  )
                ],
              ),
              SettingItem("Имя пользователя", username, false),
              SettingItem("Почта", email, true),
              ElevatedButton(
                  onPressed: signOut,
                  child: SizedBox(
                      width:
                      MediaQuery.of(context).size.width - 2.4 * kDefaultPadding,
                      child: Center(child: Text('Выйти'))))
            ],
          ),
        ));
  }

  Future<void> _displayTextInputDialog(
      BuildContext context, bool isEmail) async {
    String newValue = '';
    String currentOption = isEmail ? 'почта' : 'имя';
    String error = '';

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Поменять $currentOption'),
            content: TextField(
              decoration: InputDecoration(
                hintText: 'Введите $currentOption',
                errorText: error == '' ? null : error,
              ),
              onChanged: (value) {
                setState(() {
                  if (value.isEmpty) {
                    error = 'Пустой ввод';
                  } else if (value.length > 30) {
                    error = 'Длина должна быть меньше 30 символов';
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

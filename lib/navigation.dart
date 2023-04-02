import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/pages/archive_page.dart';
import 'package:eco_app_project/pages/home_page.dart';
import 'package:eco_app_project/pages/new_history_item_page.dart';
import 'package:eco_app_project/pages/settings_page.dart';
import 'package:eco_app_project/yandex_map/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class Navigation extends StatefulWidget {
  const Navigation({Key? key}) : super(key: key);

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {
  int _bottomNavIndex = 0;
  late DatabaseReference ref;

  final List<IconData> iconList = [
    Icons.home,
    Icons.map,
    Icons.archive,
    Icons.settings
  ];

  final List<Widget> pageList = [
    HomePage(),
    MapScreen(),
    ArchivePage(),
    SettingsPage()
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref = FirebaseDatabase.instance.ref("users/123");
  }

  Future<void> onButtonPress() async {
    var image = await ImagePicker().getImage(source: ImageSource.camera);

    if(image == null) return;

    Navigator.of(context).push(MaterialPageRoute(builder: (context) => NewHistoryItemPage(image: image)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pageList[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        onPressed: onButtonPress,
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeColor: kSecondaryColor,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        leftCornerRadius: 32,
        rightCornerRadius: 32,
        onTap: (index) => setState(() => _bottomNavIndex = index),
      ),
    );
  }
}

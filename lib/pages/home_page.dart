import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:eco_app_project/auth/auth.dart';
import 'package:eco_app_project/auth/user_model.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:eco_app_project/yandex_map/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../my_classes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  MyUser? myUser;
  final List<HistoryItem> historyItems = [];
  int pointsCount = 0;
  int dayStreak = 0;

  Future fetchData() async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/${uid}");

    var result = await ref.get();
    final data = Map<String, dynamic>.from(result.value as Map);
    myUser = MyUser.fromMap(data);
    print('my name: ${myUser!.name}');


    pointsCount = myUser!.points;
    dayStreak = myUser!.days_streak;

    return data;
  }


  @override
  void initState() {
    super.initState();

    // pointsCount = 80;
    // dayStreak = 1;
    userName = Auth().currentUser!.displayName.toString();

    // fetchData();


    historyItems.add(HistoryItem("Pitch canker on pine", 'assets/pine-pitch-canker.jpg', AppLatLong(lat: 43.224173, long: 76.916591), DateTime.now(), 30));
    historyItems.add(HistoryItem("Planted new tree", 'assets/newly_planted_tree.jpg', AppLatLong(lat: 40.730610, long: -73.935242), DateTime.now(), 50));
  }

  Widget historyCardBuilder(BuildContext context, HistoryItem historyItem) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.2, horizontal: kDefaultPadding * 0.7),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.asset(
                        historyItem.imageUri,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        repeat: ImageRepeat.noRepeat,
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.21,
                      ),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontFamily: 'Montserrat'
                      ),
                      child: Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: 0.5 * kDefaultPadding),
                          child: SizedBox(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  historyItem.title.toUpperCase(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(fontSize: kFontTitle, fontWeight: FontWeight.bold),
                                  maxLines: 2,
                                ),
                                Text(historyItem.getDate(), overflow: TextOverflow.ellipsis, maxLines: 2,),
                                Text('Points: ${historyItem.points}', overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 0,
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MapScreen(kPoint: historyItem.latLong)),
                      );
                      },
                    child: Icon(Icons.location_on),
                  ),
                )
              ],
            )
        ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: FutureBuilder(
          future: fetchData(),
          builder: (_, snapshot) {
            return Column(
              children: [
                Container(
                  height: height! * 0.35,
                  width: width,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                  ),

                  child: DefaultTextStyle(
                    style: TextStyle(
                      color: kBackgroundColor,
                      fontSize: 20,
                      fontFamily: 'Montserrat',
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(kDefaultPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          SizedBox(width: double.infinity,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Hello\,\n',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Montserrat',
                                    ),
                                    children: [
                                      TextSpan(
                                        text: userName,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 24,
                                          fontFamily: 'Montserrat',
                                        ),
                                      ),
                                      TextSpan(text: '!\n'),
                                      TextSpan(
                                          text: 'Your points:'
                                      )
                                    ],
                                  ),
                                ),
                                width: width! * 0.5 - kDefaultPadding,
                              ),
                              Flexible(
                                child: Text(
                                  pointsCount! <= 99999 ? '$pointsCount' : '99999',
                                  style: TextStyle(
                                    fontSize: min(56, 64 / (pointsCount.toString().length) * 3.5),
                                    fontWeight: FontWeight.w800,
                                    fontFamily: 'Montserrat',
                                  ),
                                ),
                              )
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: kDefaultPadding * 0.5, top: kDefaultPadding * 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Icon(
                                      Icons.local_fire_department,
                                      color: kSecondaryColor,
                                    ),
                                    Text(
                                      '$dayStreak day streak',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: 'Montserrat',
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                height: height! * 0.4 * 0.02,
                                width: width! - 2 * kDefaultPadding,
                                decoration: BoxDecoration(
                                    color: kBackgroundColor,
                                    borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
                                ),
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                  width: (width! - 2 * kDefaultPadding) * dayStreak! / 7,
                                  decoration: BoxDecoration(
                                      color: kSecondaryColor,
                                      borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
                                  ),
                                  padding: EdgeInsets.all(2),
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: CarouselSlider(
                    options: CarouselOptions(
                      height: height! * 0.5,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.2,
                      autoPlay: true,
                    ),
                    items: historyItems.map((i) {
                      return Builder(
                        builder: (BuildContext context) {
                          return historyCardBuilder(context, i);
                        },
                      );
                    }).toList(),
                  ),
                )
              ],
            );
          },
        )
    );
  }
}
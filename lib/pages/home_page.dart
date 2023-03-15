import 'package:carousel_slider/carousel_slider.dart';
import 'package:eco_app_project/auth/auth.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../my_classes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late double width, height;
  late String userName;
  late int pointsCount, dayStreak;
  final List<HistoryItem> historyItems = [];


  Widget historyCardBuilder(BuildContext context, HistoryItem historyItem) {
    return Card(
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  historyItem.plant.imageURL,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  repeat: ImageRepeat.noRepeat,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.25,
                ),
                // Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                    fontFamily: 'Montserrat'
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: kDefaultPadding),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 2 * kDefaultPadding,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(historyItem.title, overflow: TextOverflow.ellipsis),
                          Text('aaa', overflow: TextOverflow.ellipsis),
                          Text(historyItem.date.toString(), overflow: TextOverflow.ellipsis),
                          Text('Points: ${historyItem.points}', overflow: TextOverflow.ellipsis),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                            child: Row(
                              children: [
                                Spacer(),
                                SizedBox(
                                  height: 40,
                                  width: 40,
                                  child: FloatingActionButton(
                                    onPressed: () {},
                                    child: Icon(Icons.place),
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
        ),
    );
  }

  Future<void> loadFromDB() async {
    String? uid = Auth().currentUser?.uid.toString();
    final ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('users/$uid/name').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('No data available.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // loadFromDB();

    userName = Auth().currentUser?.displayName ?? 'user';
    pointsCount = 100;
    dayStreak = 1;


    historyItems.add(HistoryItem("some shit", Plant('Pine tree', 'smelly', 3, 'http://via.placeholder.com/500/500'), AppLatLong(lat: 1.0, long: 1.0), DateTime(1, 1, 1), 30));
    historyItems.add(HistoryItem("some shit 2", Plant('Pine tree', 'smelly', 3, 'http://via.placeholder.com/500/500'), AppLatLong(lat: 1.0, long: 1.0), DateTime(1, 1, 1), 30));
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Column(
          children: [
            Container(
              height: height * 0.35,
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
                          RichText(
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
                                      )
                                  ),
                                  TextSpan(text: '!\n'),
                                  TextSpan(
                                      text: 'Your points'
                                  )
                                ]
                            ),
                          ),
                          Flexible(
                            child: Text(
                              pointsCount <= 20000 ? '$pointsCount' : '20000',
                              style: TextStyle(
                                  fontSize: 64,
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
                            height: height * 0.4 * 0.02,
                            width: width - 2 * kDefaultPadding,
                            decoration: BoxDecoration(
                                color: kBackgroundColor,
                                borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
                            ),
                            alignment: Alignment.bottomLeft,
                            child: Container(
                              width: (width - 2 * kDefaultPadding) * dayStreak / 7,
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
                  height: height * 0.5,
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
        )
    );
  }
}
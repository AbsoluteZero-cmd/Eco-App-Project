import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eco_app_project/auth/auth.dart';
import 'package:eco_app_project/auth/user_model.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:eco_app_project/yandex_map/map_screen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../my_classes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? userName;
  MyUser? myUser;
  List<HistoryItem> historyItems = [];
  int pointsCount = 0;
  int dayStreak = 0;

  late PageController _controller;

  Future fetchData() async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

    userName = Auth().currentUser!.displayName.toString();

    var result = await ref.get();
    final data = Map<String, dynamic>.from(result.value as Map);
    myUser = MyUser.fromMap(data);


    pointsCount = myUser!.points;
    dayStreak = myUser!.days_streak;

    DatabaseReference refHistory = FirebaseDatabase.instance.ref("history/$uid");
    result = await refHistory.get();

    List<HistoryItem> list = [];

    for (var element in result.children) {
      var data2 = Map<String, dynamic>.from(element.value as Map);
      final historyItem = HistoryItem.fromMap(data2);
      list.add(historyItem);
    }

    historyItems = list;
    return result;
  }

  @override
  void initState() {
    super.initState();

    _controller = PageController();
  }

  Widget historyCardBuilder(BuildContext context, HistoryItem historyItem, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SizedBox(
      width: width * 0.8,
      height: height * 0.5,
      child: Center(
        child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 5.0),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: kDefaultPadding * 0.2, horizontal: kDefaultPadding * 0.2),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: CachedNetworkImage(
                            imageUrl: historyItem.imageUri,
                            fit: BoxFit.cover,
                            alignment: Alignment.center,
                            repeat: ImageRepeat.noRepeat,
                            width: width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.21,
                            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          ),
                        ),
                        DefaultTextStyle(
                          style: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                            fontFamily: 'Montserrat'
                          ),
                          child: Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: kDefaultPadding, horizontal: 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    historyItem.title.toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(fontSize: kFontTitle, fontWeight: FontWeight.bold),
                                    maxLines: 2,
                                  ),
                                  Text(historyItem.date, overflow: TextOverflow.ellipsis, maxLines: 2,),
                                  Text('Points: ${historyItem.points}', overflow: TextOverflow.ellipsis),
                                ],
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
                        onPressed: () async {
                          await deleteHistoryItem(historyItem.id, index);
                        },
                        child: const Icon(Icons.delete),
                      ),
                    )
                  ],
                )
            ),
        ),
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
            if(snapshot.hasData){
              return Column(
                children: [
                  Container(
                    height: height* 0.35,
                    width: width,
                    decoration: const BoxDecoration(
                      color: kPrimaryColor,
                    ),

                    child: DefaultTextStyle(
                      style: const TextStyle(
                        color: kBackgroundColor,
                        fontSize: 20,
                        fontFamily: 'Montserrat',
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(kDefaultPadding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            const SizedBox(width: double.infinity,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width* 0.5 - kDefaultPadding,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Hello,\n',
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Montserrat',
                                      ),
                                      children: [
                                        TextSpan(
                                          text: userName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 24,
                                            fontFamily: 'Montserrat',
                                          ),
                                        ),
                                        const TextSpan(text: '!\n'),
                                        const TextSpan(
                                            text: 'Your points:'
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    pointsCount<= 99999 ? '$pointsCount' : '99999',
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
                                      const Icon(
                                        Icons.local_fire_department,
                                        color: kSecondaryColor,
                                      ),
                                      Text(
                                        '$dayStreak day streak',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontFamily: 'Montserrat',
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height: height* 0.4 * 0.02,
                                  width: width- 2 * kDefaultPadding,
                                  decoration: const BoxDecoration(
                                      color: kBackgroundColor,
                                      borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
                                  ),
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    width: (width- 2 * kDefaultPadding) * dayStreak/ 7,
                                    decoration: const BoxDecoration(
                                        color: kSecondaryColor,
                                        borderRadius: BorderRadius.all(Radius.circular(kBorderRadius))
                                    ),
                                    padding: const EdgeInsets.all(2),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: height * 0.55,
                    width: width,
                    child: historyItems.isNotEmpty ?
                    ListView.builder(
                      itemCount: historyItems.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 0.1 * width),
                            child: historyCardBuilder(context, historyItems[index], index),
                          ),
                        );
                      },
                    ) : Container(
                      padding: const EdgeInsets.all(1.5 * kDefaultPadding),
                      child: Center(child: Text('Пока что тут пусто'),)
                    ),
                  )
                ],
              );
            }
            else{
              return const Center(child: CircularProgressIndicator());
            }
          },
        )
    );
  }

  Future<void> deleteHistoryItem(String id, int index) async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference reference = FirebaseDatabase.instance.ref('/history/${uid}/${id}');
    print('my ref ${reference.path}');
    reference.remove();

    setState(() {
      historyItems.removeAt(index);
    });
  }
}
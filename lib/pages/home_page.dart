import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eco_app_project/auth/auth.dart';
import 'package:eco_app_project/auth/user_model.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/pages/history_item_edit_page.dart';
import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:firebase_database/firebase_database.dart';
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

  Future<void> fetchUserData() async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref("users/$uid");

    userName = Auth().currentUser!.displayName.toString();

    var result = await ref.get();
    final data = Map<String, dynamic>.from(result.value as Map);
    myUser = MyUser.fromMap(data);

    pointsCount = myUser!.points;
    dayStreak = myUser!.days_streak;
  }

  Future<void> fetchHistoryItemsData() async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference refHistory =
        FirebaseDatabase.instance.ref("history/$uid");
    var result = await refHistory.get();

    List<HistoryItem> list = [];

    for (var element in result.children) {
      var elementData = Map<String, dynamic>.from(element.value as Map);
      final historyItem = HistoryItem.fromMap(elementData);

      var uris = element.child("imageUris").value;
      List<String> strings = [];
      if (uris != null) {
        var urisData = uris as List<Object?>;
        for (var i in urisData) {
          strings.add(i.toString());
        }
      }
      historyItem.imageUris.addAll(strings);
      list.add(historyItem);
    }
    // list.add(HistoryItem(
    //     title: 'title',
    //     imageUris: [
    //       'https://firebasestorage.googleapis.com/v0/b/ecoapp-1b718.appspot.com/o/history%2FFK35xliYGRbccOH9iSD5ZYfpUZn2%2F1689240736552%2Faf9deade-95d1-4c96-abea-9822d3b08f579212873894571622583.jpg?alt=media&token=2ad4c8a1-dc6c-4dac-a8f2-7c8d1d10e750'
    //     ],
    //     latLong: '36.4219983 -123.084',
    //     date: 'Thursday, Jul 13, 2023',
    //     points: 100,
    //     description: 'description',
    //     id: '11111111',
    //     age: 23,
    //     height: 34,
    //     status: 'Больное'));

    historyItems = list;
    print('my history: ${historyItems}');
  }

  Future<bool> fetchData() async {
    await fetchUserData();
    await fetchHistoryItemsData();

    return true;
  }

  @override
  void initState() {
    super.initState();
  }

  Widget historyCardBuilder(
      BuildContext context, HistoryItem historyItem, int index) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color _chipColor, _labelColor;

    switch (historyItem.status) {
      case 'Больное':
        _chipColor = Colors.red;
        _labelColor = Colors.white;
        break;
      case 'Аварийное':
        _chipColor = Colors.yellow;
        _labelColor = Colors.black;
        break;
      case 'Здоровое':
        _chipColor = Colors.green;
        _labelColor = Colors.white;
        break;
      default:
        _chipColor = Colors.grey;
        _labelColor = Colors.black;
    }

    return SizedBox(
      width: width * 0.8,
      height: height * 0.5,
      child: Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          shape: LinearBorder(),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  historyItem.imageUris.length > 0
                      ? SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.9,
                          child: SingleChildScrollView(
                              child: Wrap(
                            alignment: WrapAlignment.spaceBetween,
                            runAlignment: WrapAlignment.spaceBetween,
                            children: historyItem.imageUris.map((imageUri) {
                              return CachedNetworkImage(
                                imageUrl: imageUri,
                                placeholder: (context, url) => SizedBox(
                                    height: 50,
                                    width: 50,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                              );
                            }).toList(),
                          )),
                        )
                      : CircularProgressIndicator(),
                  DefaultTextStyle(
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                        fontFamily: 'Montserrat'),
                    child: Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: kDefaultPadding, horizontal: 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              historyItem.title.toUpperCase(),
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  fontSize: kFontTitle,
                                  fontWeight: FontWeight.bold),
                              maxLines: 2,
                            ),
                            Text(
                              historyItem.date,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            Text('Очки: ${historyItem.points}',
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: 0,
                  right: 0,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  pageBuilder: (_, __, ___) =>
                                      HistoryItemEditPage(
                                        historyItem: historyItem,
                                      )));
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () async {
                          await deleteHistoryItem(historyItem.id, index);
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  )),
              Positioned(
                child: Chip(
                  label: Text(historyItem.status),
                  labelStyle: TextStyle(color: _labelColor),
                  backgroundColor: _chipColor,
                ),
                top: 5,
                left: 10,
              )
            ],
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
            if (snapshot.hasData) {
              return Column(
                children: [
                  Container(
                    height: height * 0.35,
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
                            const SizedBox(
                              width: double.infinity,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: width * 0.5 - kDefaultPadding,
                                  child: RichText(
                                    text: TextSpan(
                                      text: 'Привет,\n',
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
                                        const TextSpan(text: 'Ваши баллы:')
                                      ],
                                    ),
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    pointsCount <= 99999
                                        ? '$pointsCount'
                                        : '99999',
                                    style: TextStyle(
                                      fontSize: min(
                                          56,
                                          64 /
                                              (pointsCount.toString().length) *
                                              3.5),
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
                                  padding: const EdgeInsets.only(
                                      bottom: kDefaultPadding * 0.5,
                                      top: kDefaultPadding * 2),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department,
                                        color: kSecondaryColor,
                                      ),
                                      Text(
                                        '$dayStreak дней подряд',
                                        style: const TextStyle(
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
                                  decoration: const BoxDecoration(
                                      color: kBackgroundColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(kBorderRadius))),
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                    width: (width - 2 * kDefaultPadding) *
                                        dayStreak /
                                        7,
                                    decoration: const BoxDecoration(
                                        color: kSecondaryColor,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(kBorderRadius))),
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
                    child: historyItems.isNotEmpty
                        ? ListView.builder(
                            itemCount: historyItems.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 24, horizontal: 0.1 * width),
                                  child: historyCardBuilder(
                                      context, historyItems[index], index),
                                ),
                              );
                            },
                          )
                        : Container(
                            padding:
                                const EdgeInsets.all(1.5 * kDefaultPadding),
                            child: Center(
                              child: Text('Пока что тут пусто'),
                            )),
                  )
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }

  Future<void> deleteHistoryItem(String id, int index) async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference reference =
        FirebaseDatabase.instance.ref('/history/${uid}/${id}');
    reference.remove();

    setState(() {
      historyItems.removeAt(index);
    });
  }
}

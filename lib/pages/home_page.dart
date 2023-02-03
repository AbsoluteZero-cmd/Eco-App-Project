import 'package:carousel_slider/carousel_slider.dart';
import 'package:eco_app_project/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget historyCardBuilder(BuildContext context, int i) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(kBorderRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0.5,
                blurRadius: 3,
                offset: Offset(3, 3), // changes position of shadow
              ),
            ]
        ),
        child: Padding(
            padding: const EdgeInsets.all(kDefaultPadding * 0.5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1502311526760-ebc5d6cc0183?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=326&q=80',
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

                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: kDefaultPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Title: Some tree'),
                        Text('Where: Satpaev street'),
                        Text('When: 19.08.22'),
                        Text('Points: +500')
                      ],
                    ),
                  ),
                )
              ],
            )
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final String userName = 'Aidana';
    final int pointsCount = 13900;
    final int dayStreak = 4;

    final List<int> historyItems = [1, 2, 3];

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
                        children: [
                          RichText(
                            text: TextSpan(
                                text: 'Hello\,\n',
                                style: TextStyle(
                                    fontSize: 20
                                ),
                                children: [
                                  TextSpan(
                                      text: userName,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 24
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
                                  fontWeight: FontWeight.w800
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
                                      fontSize: 16
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
                  height: height * 0.45,
                  enlargeCenterPage: true,
                  enlargeFactor: 0.2,
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
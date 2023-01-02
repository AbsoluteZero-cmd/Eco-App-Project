import 'package:carousel_slider/carousel_slider.dart';
import 'package:eco_app_project/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Widget historyCardBuilder(BuildContext context, int i) {
    return Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(horizontal: 5.0),
        decoration: BoxDecoration(
          color: kSecondaryColor,
          borderRadius: BorderRadius.circular(kBorderRadius * 0.5),
          boxShadow: [
            BoxShadow(
              color: kSecondaryColor.withOpacity(0.5),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ]
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('text $i', style: TextStyle(fontSize: 16.0),),
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
            child: Container(
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
            ),
          )
        ],
      )
    );
  }
}

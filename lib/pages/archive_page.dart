import 'package:cached_network_image/cached_network_image.dart';
import 'package:eco_app_project/pages/archive_detail_page.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ArchivePage extends StatefulWidget {
  const ArchivePage({Key? key}) : super(key: key);

  @override
  State<ArchivePage> createState() => _ArchivePageState();
}

class _ArchivePageState extends State<ArchivePage> {

  late PageController _pageController;
  String? _dropdownOption;
  late List<DropdownMenuItem<String>> sortingOptions;
  List<Plant> plants = [];

  late final Future myFuture;

  @override
  initState(){
    super.initState();

    sortingOptions = [
      DropdownMenuItem(value: '1',child: Text('По имени'),),
      DropdownMenuItem(value: '2',child: Text('По редкости'),),
    ];

    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);

    myFuture = fetchData();
  }

  Future fetchData() async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("plants/");

    final List<Plant> list = [];
    var data = await ref.get();
    for (var element in data.children) {
      var data2 = Map<String, dynamic>.from(element.value as Map);
      final plant = Plant.fromMap(data2);
      list.add(plant);
    }

    plants = list;
    return data;
  }

  _plantSelector(index) {
    return Stack(
      alignment: Alignment.center,

      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(horizontal: kDefaultPadding * 0.3),
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(kBorderRadius)
          ),

          height: double.infinity,
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                bottom: 10,
                left: 10,
                child: Text(
                    plants[index].name,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: kFontTitle
                    )
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                        'Редкость',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: kFontTitle * 0.8,
                        )
                    ),
                    Row(
                      children: [
                        for(int i = 0; i < plants[index].rarity; i++) Icon(Icons.star, color: Colors.white),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          pageBuilder: (_, __, ___) => ArchiveDetailPage(plant: plants[index])
                      )
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Hero(
                    tag: 'plant${plants[index].name}',
                    child: CachedNetworkImage(
                      fit: BoxFit.fitWidth,
                      height: 400,
                      imageUrl: plants[index].imageURL,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),

      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: myFuture,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: kDefaultPadding * 1.2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                  child: Text(
                    'Каталог растений',
                    style: TextStyle(
                        fontSize: kFontTitle,
                        fontWeight: FontWeight.bold
                    ),

                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: kDefaultPadding),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: DropdownButton<String>(
                      hint: Text('Отсортировать растения'),
                      isExpanded: true,
                      items: sortingOptions,
                      value: _dropdownOption,
                      onChanged: (value) {
                        setState(() {
                          _dropdownOption = value;

                          if(_dropdownOption == '1'){
                            setState(() {
                              plants.sort((a, b) => a.name.compareTo(b.name));
                            });
                          }
                          else if(_dropdownOption == '2'){
                            setState(() {
                              plants.sort((a, b) => a.rarity - b.rarity);
                            });
                          }
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                      controller: _pageController,
                      itemCount: plants.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return _plantSelector(index);
                      }),
                )
              ],
            ),
          );
        }
        else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}


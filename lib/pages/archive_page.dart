import 'package:eco_app_project/pages/archive_detail_page.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import '../auth/auth.dart';
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

  @override
  initState(){
    super.initState();

    sortingOptions = [
      DropdownMenuItem(child: Text('By name'), value: '1',),
      DropdownMenuItem(child: Text('By rarity'), value: '2',),
    ];

    plants = [
      Plant('Pine tree', 'High and smelly', 3, ''),
      Plant('Magnolia', 'Cute', 4, 'https://static.vecteezy.com/system/resources/previews/009/390/943/original/watercolor-white-magnolia-flower-and-leaf-branch-bouquet-png.png'),
      Plant('Grass', 'Totally normal', 1, 'https://purepng.com/public/uploads/large/purepng.com-grassgrasstype-of-plantgrasslandgrass-lawn-1411527053156hdv8f.png'),
    ];

    for(int i = 0; i < 4; i++) plants[1].addDisease(Disease('some shit' + i.toString(), 3, 'Blue points on the flowers'));


    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);
  }

  Future fetchData() async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference ref = FirebaseDatabase.instance.ref("plants/");

    final List<Plant> list = [];
    var data = await ref.get();
    data.children.forEach((element) {
      var data2 = Map<String, dynamic>.from(element.value as Map);
      final plant = Plant.fromMap(data2);
      print(data2);
      list.add(plant);
    });

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
                        'Rarity',
                        style: TextStyle(
                            color: Colors.white,
                            // fontWeight: FontWeight.w600,
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
                    tag: 'plant' + plants[index].name,
                    child: Image(
                      fit: BoxFit.fitWidth,
                      height: 400,
                      // 'assets/pine_tree_placeholder.png'
                      image: plants[index].imageURL != '' ? NetworkImage(plants[index].imageURL) : AssetImage('assets/pine_tree_placeholder.png') as ImageProvider,
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
      future: fetchData(),
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
                    'Plants archive',
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
                      hint: Text('Select sorting option'),
                      isExpanded: true,
                      items: sortingOptions,
                      value: _dropdownOption,
                      onChanged: (value) {
                        setState(() {
                          _dropdownOption = value;

                          if(_dropdownOption == '1'){
                            plants.sort((a, b) => a.name.compareTo(b.name));
                          }
                          else if(_dropdownOption == '2'){
                            plants.sort((a, b) => a.rarity - b.rarity);
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
        else return Center(child: CircularProgressIndicator());
      },
    );
  }
}


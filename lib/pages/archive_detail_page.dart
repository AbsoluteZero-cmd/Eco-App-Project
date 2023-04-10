import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/my_classes.dart';
import 'package:flutter/material.dart';

class ArchiveDetailPage extends StatelessWidget {
  const ArchiveDetailPage({super.key, required this.plant});

  final Plant plant;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: 'plant' + plant.name,
              child: Image(
                fit: BoxFit.fitWidth,
                height: 500,
                image: plant.imageURL != '' ? NetworkImage(plant.imageURL) : AssetImage('assets/pine_tree_placeholder.png') as ImageProvider
              ),
            ),
            Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      plant.name,
                      style: TextStyle(
                        fontSize: kFontTitle,
                      ),
                    ),
                    Text(plant.description),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        plant.diseases == null ? Text('No diseases!') : Column(
                          children: [
                            Text('Diseases'),
                            Container(
                              width: MediaQuery.of(context).size.width - 2 * kDefaultPadding,
                              height: MediaQuery.of(context).size.height * 0.1,
                              child: diseasesList(),
                            )
                          ],
                        )
                      ],
                    )
                  ],
                )
            )
          ]
        ),
      ),
    );
  }

  Widget diseasesList() {
    return PageView.builder(
        itemCount: plant.diseases.length,
        pageSnapping: true,
        itemBuilder: (context, index){
          return Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(plant.diseases[index].name.toUpperCase()),
                    Spacer(),
                    Text(plant.diseases[index].infection_level.toString()),
                    Icon(Icons.star, color: Colors.red,)
                  ],
                ),
                Text(plant.diseases[index].description)
              ],
            )
          );
        });
  }
}

import 'package:cached_network_image/cached_network_image.dart';
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
        padding: EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 2 * kDefaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Hero(
              tag: 'plant${plant.name}',
              // child: Image(
              //   fit: BoxFit.fitWidth,
              //   height: 500,
              //   image: plant.imageURL != '' ? NetworkImage(plant.imageURL) : AssetImage('assets/pine_tree_placeholder.png') as ImageProvider
              // ),
              child: CachedNetworkImage(
                fit: BoxFit.fitWidth,
                height: 500,
                imageUrl: plant.imageURL,
                placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
              ),
            ),
            Expanded(
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      plant.name,
                      style: TextStyle(
                        fontSize: kFontTitle,
                      ),
                    ),
                    Text(plant.description),
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

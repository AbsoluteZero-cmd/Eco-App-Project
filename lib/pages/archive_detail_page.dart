import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/plant._model.dart';
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
            )
          ],
        ),
      ),
    );
  }
}

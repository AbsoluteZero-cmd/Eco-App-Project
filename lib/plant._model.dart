import 'package:firebase_database/firebase_database.dart';

class Plant {
  late String name;
  late String description;
  late String imageURL;
  late int rarity;


  Plant(String name, String description, int rarity, String imageURL){
    this.name = name;
    this.description = description;
    this.rarity = rarity;
    this.imageURL = imageURL;
  }

  Plant.fromDb(DataSnapshot data) {

  }

}

import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Plant {
  late String name;
  late String description;
  late String imageURL;
  late int rarity;
  List<Disease> diseases = [];


  Plant(String name, String description, int rarity, String imageURL){
    this.name = name;
    this.description = description;
    this.rarity = rarity;
    this.imageURL = imageURL;
  }

  void addDisease(Disease disease){
    this.diseases.add(disease);
  }
}

class Disease {
  late String name;
  late int infection_level;
  late String description;

  Disease(String name, int infection_level, String description){
    this.name = name;
    this.infection_level = infection_level;
    this.description = description;
  }
}

class HistoryItem{
  String title;
  String imageUri;
  int points;
  DateTime date;
  AppLatLong latLong;

  HistoryItem(this.title, this.imageUri, this.latLong, this.date, this.points);

}
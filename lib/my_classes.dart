
import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:intl/intl.dart';

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
    diseases.add(disease);
  }


  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "imageURL": imageURL,
      "rarity": rarity,
      "diseases": diseases,
    };
  }

  Plant.fromMap(Map<String, dynamic> addressMap)
      : name = addressMap["name"],
        description = addressMap["description"],
        imageURL = addressMap["imageURL"],
        rarity = addressMap["rarity"],
        diseases = addressMap["diseases"];
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

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "infection_level": infection_level,
    };
  }

  Disease.fromMap(Map<String, dynamic> addressMap)
      : name = addressMap["name"],
        description = addressMap["description"],
        infection_level = addressMap["infection_level"];
}

class HistoryItem{
  String title;
  String imageUri;
  int points;
  String date;
  String latLong;
  String description;
  String id;

  HistoryItem({
      required this.title,
      required this.imageUri,
      required this.latLong,
      required this.date,
      required this.points,
      required this.description,
      required this.id,
  });

  static getDate(DateTime date){
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  AppLatLong getLatLong() {
    return AppLatLong(lat: double.parse(latLong.substring(0, latLong.indexOf(' '))), long: double.parse(latLong.substring(latLong.indexOf(' ') + 1)));
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "imageUri": imageUri,
      "points": points,
      "date": date,
      "latLong": latLong,
      "description": description,
      "id": id,
    };
  }

  HistoryItem.fromMap(Map<String, dynamic> addressMap)
      : title = addressMap["title"],
        imageUri = addressMap["imageUri"],
        points = addressMap["points"],
        date = addressMap["date"],
        latLong = addressMap["latLong"],
        description = addressMap["description"],
        id = addressMap["id"];
}
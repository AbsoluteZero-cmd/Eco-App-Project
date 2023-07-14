import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:intl/intl.dart';

class Plant {
  late String name;
  late String description;
  late String imageURL;
  late int rarity;

  Plant(String name, String description, int rarity, String imageURL) {
    this.name = name;
    this.description = description;
    this.rarity = rarity;
    this.imageURL = imageURL;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "description": description,
      "imageURL": imageURL,
      "rarity": rarity,
    };
  }

  Plant.fromMap(Map<String, dynamic> addressMap)
      : name = addressMap["name"],
        description = addressMap["description"],
        imageURL = addressMap["imageURL"],
        rarity = addressMap["rarity"];
}

class Disease {
  late String name;
  late int infection_level;
  late String description;

  Disease(String name, int infection_level, String description) {
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

class HistoryItem {
  String title;
  List<String> imageUris;
  int points;
  String date;
  String latLong;
  String description;
  String id;

  late int age;
  late int height;
  late String status;

  static List<String> statusList = [
    "Больное",
    "Аварийное",
    "Здоровое",
  ];

  HistoryItem({
    required this.title,
    required this.imageUris,
    required this.latLong,
    required this.date,
    required this.points,
    required this.description,
    required this.id,
    required this.age,
    required this.height,
    required this.status,
  });

  static getDate(DateTime date) {
    return DateFormat('EEEE, MMM d, yyyy').format(date);
  }

  AppLatLong getLatLong() {
    return AppLatLong(
        lat: double.parse(latLong.substring(0, latLong.indexOf(' '))),
        long: double.parse(latLong.substring(latLong.indexOf(' ') + 1)));
  }

  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "imageUris": imageUris,
      "points": points,
      "date": date,
      "latLong": latLong,
      "description": description,
      "id": id,
      "age": age,
      "height": height,
      "status": status,
    };
  }

  HistoryItem.fromMap(Map<String, dynamic> addressMap)
      : title = addressMap["title"],
        imageUris = [],
        points = addressMap["points"],
        date = addressMap["date"],
        latLong = addressMap["latLong"],
        description = addressMap["description"],
        age = addressMap["age"],
        height = addressMap["height"],
        status = addressMap["status"],
        id = addressMap["id"];
}

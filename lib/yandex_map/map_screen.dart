import 'dart:async';

import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:eco_app_project/yandex_map/location_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

import '../auth/auth.dart';
import '../my_classes.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    this.kPoint = const AppLatLong(lat: 0, long: 0),
    Key? key,
  }) : super(key: key);

  final AppLatLong kPoint;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final mapControllerCompleter = Completer<YandexMapController>();


  final List<MapObject> mapObjects = [];



  PlacemarkMapObject getPlacemarkMapObject(double lat, double long, [String date = 'Date of planting']){
    return PlacemarkMapObject(
      mapId: MapObjectId(lat.toString() + long.toString()),
      point: Point(latitude: lat, longitude: long),
      opacity: 1,
      icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromAssetImage('assets/Yandex_Maps_icon.png'),
            scale: 0.05,
            rotationType: RotationType.noRotation,
          )
      ),
      onTap: (mapObject, point) {
        Fluttertoast.showToast(
          msg: date,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
        );
      },
    );
  }


  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = AlmatyLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }

    if(!(widget.kPoint.lat == 0 && widget.kPoint.long == 0)) location = widget.kPoint;
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
      AppLatLong appLatLong,
      ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 0.95),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  Future fetchData() async {
    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference refHistory = FirebaseDatabase.instance.ref("history/$uid");
    var result = await refHistory.get();

    List<MapObject> objects = [];
    for (var element in result.children) {
      var data2 = Map<String, dynamic>.from(element.value as Map);
      final historyItem = HistoryItem.fromMap(data2);
      objects.add(getPlacemarkMapObject(historyItem.getLatLong().lat, historyItem.getLatLong().long, historyItem.date));
    }

    setState(() {
      mapObjects.addAll(objects);
    });
  }

  @override
  initState() {
    super.initState();
    _initPermission().ignore();

    // mapObjects.add(getPlacemarkMapObject(43.224173, 76.916591));
    // mapObjects.add(getPlacemarkMapObject(40.730610, -73.935242));

    final mapObject = CircleMapObject(
      mapId: MapObjectId('rounded_area'),
      circle: Circle(
        center: Point(latitude: 43.225777, longitude: 76.927366),
        radius: 100,
      ),
      strokeColor: Colors.green[700]!,
      strokeWidth: 5,
      fillColor: Colors.green[300]!,
      onTap: (CircleMapObject self, Point point) async {
        final address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(43.225777, 76.927366));
        var first = address.first;
        Fluttertoast.showToast(
            msg: first.addressLine,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
        );
      },
    );

    mapObjects.add(mapObject);

    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          YandexMap(
            onMapCreated: (controller) {
              mapControllerCompleter.complete(controller);
            },
            mapObjects: mapObjects,
            mode2DEnabled: true,
          ),
          Positioned(
            left: 10,
            bottom: 10,
            child: FloatingActionButton.small(
              onPressed: () {
                _fetchCurrentLocation();
              },
              backgroundColor: Colors.white,
              child: const Icon(Icons.location_searching, color: Colors.black54,),
            ),
          )
        ],
      ),
    );
  }

}
import 'dart:async';

import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:eco_app_project/yandex_map/location_service.dart';
import 'package:flutter/material.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

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


  PlacemarkMapObject getPlacemarkMapObject(double lat, double long){
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
        print('click on ${mapObject.mapId}');
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
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 12,
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();

    mapObjects.add(getPlacemarkMapObject(44.2504832, 75.8770048));
    mapObjects.add(getPlacemarkMapObject(44.2504842, 79.8770048));
    mapObjects.add(getPlacemarkMapObject(44.2584832, 15.8770048));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: YandexMap(
        onMapCreated: (controller) {
          mapControllerCompleter.complete(controller);
        },
        mapObjects: mapObjects,
      ),
    );
  }

}
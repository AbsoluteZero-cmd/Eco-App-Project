import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eco_app_project/constants.dart';
import 'package:eco_app_project/yandex_map/app_lat_long.dart';
import 'package:eco_app_project/yandex_map/location_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
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



  PlacemarkMapObject getPlacemarkMapObject(HistoryItem historyItem){
    double lat = historyItem.getLatLong().lat;
    double long = historyItem.getLatLong().long;

    return PlacemarkMapObject(
      mapId: MapObjectId(lat.toString() + long.toString()),
      point: Point(latitude: lat, longitude: long),
      opacity: 1,
      onTap: (mapObject, point) {
        showModalBottomSheet<void>(
          context: context,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topRight: Radius.circular(10), topLeft: Radius.circular(10)),
          ),
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(kDefaultPadding),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(historyItem.title, style: TextStyle(fontSize: kFontTitle * 0.8)),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: historyItem.imageUris.length > 0 ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4,
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: historyItem.imageUris.map((imageUri){
                                    return Container(
                                      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.0),
                                      height: MediaQuery.of(context).size.height * 0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: AspectRatio(
                                        aspectRatio: 5 / 7,
                                        child: CachedNetworkImage(imageUrl: imageUri, placeholder: (context, url) => SizedBox(height: 50, width: 50, child: Center(child: CircularProgressIndicator())),),
                                      ),
                                    );
                                  }).toList(),
                                )
                            ),
                          ) : CircularProgressIndicator()
                      ),
                      Text('Описание болезни: ${historyItem.description}'),
                      Text(
                        historyItem.date,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      )
                    ],
                  )
                ],
              ),
            );
          },
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
    List<MapObject> objects = [];
    // String? uid = Auth().currentUser?.uid.toString();
    // DatabaseReference refHistory = FirebaseDatabase.instance.ref("history/$uid");
    // var result = await refHistory.get();
    //
    // List<MapObject> objects = [];
    // for (var element in result.children) {
    //   var data2 = Map<String, dynamic>.from(element.value as Map);
    //   final historyItem = HistoryItem.fromMap(data2);
    //   objects.add(getPlacemarkMapObject(historyItem));
    // }
    //


    // DatabaseReference reference = FirebaseDatabase.instance.ref("history");
    // var result = await reference.get();
    // for(var i in result.children){
    //   for(var element in i.children){
    //     var data2 = Map<String, dynamic>.from(element.value as Map);
    //     final historyItem = HistoryItem.fromMap(data2);
    //     objects.add(getPlacemarkMapObject(historyItem));
    //   }
    // }

    String? uid = Auth().currentUser?.uid.toString();
    DatabaseReference refHistory = FirebaseDatabase.instance.ref("history/$uid");
    var result = await refHistory.get();


    for (var element in result.children) {
      var elementData = Map<String, dynamic>.from(element.value as Map);
      final historyItem = HistoryItem.fromMap(elementData);


      var uris = element
          .child("imageUris")
          .value;
      List<String> strings = [];
      if (uris != null) {
        var urisData = uris as List<Object?>;
        for (var i in urisData) {
          strings.add(i.toString());
        }
      }
      historyItem.imageUris.addAll(strings);
      objects.add(getPlacemarkMapObject(historyItem));
    }


    setState(() {
      mapObjects.addAll(objects);
    });
  }

  @override
  initState() {
    super.initState();
    _initPermission().ignore();

    // final mapObject = CircleMapObject(
    //   mapId: MapObjectId('rounded_area'),
    //   circle: Circle(
    //     center: Point(latitude: 43.225777, longitude: 76.927366),
    //     radius: 100,
    //   ),
    //   strokeColor: Colors.green[700]!,
    //   strokeWidth: 5,
    //   fillColor: Colors.green[300]!,
    //   onTap: (CircleMapObject self, Point point) async {
    //     final address = await Geocoder.local.findAddressesFromCoordinates(Coordinates(43.225777, 76.927366));
    //     var first = address.first;
    //     Fluttertoast.showToast(
    //         msg: first.addressLine,
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.TOP,
    //         timeInSecForIosWeb: 1,
    //     );
    //   },
    // );

    // mapObjects.add(mapObject);

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

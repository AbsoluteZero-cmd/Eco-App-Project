import 'dart:ffi';

class AppLatLong {
  final double lat;
  final double long;

  const AppLatLong({
    required this.lat,
    required this.long,
  });

  @override
  String toString() {
    // TODO: implement toString
    return lat.toString() + ' ' + long.toString();
  }

  AppLatLong.fromString(String latlong):
        lat = double.parse(latlong.substring(0, latlong.indexOf(' '))),
        long = double.parse(latlong.substring(latlong.indexOf(' ') + 1));
}

class MoscowLocation extends AppLatLong {
  const MoscowLocation({
    super.lat = 55.7522200,
    super.long = 37.6155600,
  });
}

class AlmatyLocation extends AppLatLong {
  const AlmatyLocation({
    super.lat = 43.238949,
    super.long = 76.889709,
  });
}
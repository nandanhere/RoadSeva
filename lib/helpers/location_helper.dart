import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math' as Math;

const GOOGLE_API_KEY = 'AIzaSyAyBrrrsIrOP5z1tz1u1vLtan2l0b__uPI';

class LocationHelper {
  double rad(double x) {
    return x * Math.pi / 180;
  }

  double getD(LatLng p1, LatLng p2) {
    double R = 6378137;
    double dLat = rad(p2.latitude - p1.latitude);
    double dLong = rad(p2.longitude - p1.longitude);
    double a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(rad(p1.latitude)) *
            Math.cos(rad(p2.latitude)) *
            Math.sin(dLong / 2) *
            Math.sin(dLong / 2);
    double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  }

  static String generateLocationPreviewImage(
      {double latitude, double longitude, double width, double height}) {
    return 'https://osm-static-maps.herokuapp.com/?height=${height ~/ 4}&width=${(width / 1.3) ~/ 1}&center=$longitude,$latitude&zoom=14&markers=$longitude,$latitude,lightblue1';
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    final url =
        "https://forward-reverse-geocoding.p.rapidapi.com/v1/reverse?lat=$lat&lon=$long&format=json&accept-language=en&polygon_threshold=0.0";
    final response = await http.get(url, headers: {
      "x-rapidapi-key": "f46aab0a5emsh04a8f3b8c25f395p14f0c6jsnb9e9d0b9f965",
      "x-rapidapi-host": "forward-reverse-geocoding.p.rapidapi.com"
    });
    if (response == null) {
      return "The pothole is near (${lat.toStringAsPrecision(2)},${long.toStringAsPrecision(2)})";
    }
    final map = json.decode(response.body);

    String road = map['address']['road'];
    return road == null ? map['display_name'] : road;
  }
}

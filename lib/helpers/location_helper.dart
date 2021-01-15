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
      {double latitude, double longitude}) {
    return "https://maps.googleapis.com/maps/api/staticmap?center=Brooklyn+Bridge,New+York,NY&zoom=13&size=600x300&maptype=roadmap&markers=color:blue%7Clabel:S%7C40.702147,-74.015794&markers=color:green%7Clabel:G%7C40.711614,-74.012318&markers=color:red%7Clabel:C%7C40.718217,-73.998284&key=$GOOGLE_API_KEY";
  }

  static Future<String> getPlaceAddress(double lat, double long) async {
    return "The address wil be here if api was paid for";
    // final url =
    //     "https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$long&key=$GOOGLE_API_KEY";
    // final response = await http.get(url);
    // if (response == null) return "hell";
    // print(response);
    // return json.decode(response.body)['results'][0]['formatted_address'];
  }
}

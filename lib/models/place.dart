import 'dart:io';
import 'package:flutter/foundation.dart';

class PotHoleDetails {
  final double latitude, longitude;
  final String address;
  final String url;
  const PotHoleDetails(
      {@required this.latitude,
      @required this.longitude,
      this.address,
      this.url});
}

class Place {
  final String id;
  final String title;
  final PotHoleDetails location;
  final File image;
  Place(
      {@required this.id,
      @required this.title,
      @required this.location,
      @required this.image});
}

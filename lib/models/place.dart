import 'dart:io';
import 'package:flutter/foundation.dart';

class PotHole {
  final double latitude, longitude;
  final String address;
  final String url;
  const PotHole(
      {@required this.latitude,
      @required this.longitude,
      this.address,
      this.url});
}

class Place {
  final String id;
  final String title;
  final PotHole location;
  final File image;
  Place(
      {@required this.id,
      @required this.title,
      @required this.location,
      @required this.image});
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:road_seva/models/place.dart';
import 'package:road_seva/screens/map_screen.dart';

import 'package:flutter/material.dart';
import 'package:road_seva/widgets/image_input.dart';

import '../models/place.dart';

class ComplaintRegisterScreen extends StatelessWidget {
  static const routeName = "/complaint_register";
  final List<DocumentSnapshot> potholes;
  const ComplaintRegisterScreen({Key key, this.potholes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Map<String, LocationData> args =
        ModalRoute.of(context).settings.arguments;
    return MapScreen(
      potholes: potholes,
      latitude: args['location'].latitude,
      longitude: args['location'].longitude,
      isSelecting: true,
    );
  }
}

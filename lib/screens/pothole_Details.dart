import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:road_seva/helpers/location_helper.dart';

class PotholeDetails extends StatelessWidget {
  static const String routeName = "/pothole_details";
  const PotholeDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    DocumentSnapshot snap = args['document'];
    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
      ),
      body: Column(
        children: [
          Image.network(LocationHelper.generateLocationMapImage(
              height: size.height - 200,
              latitude: snap['latitude'],
              width: size.width,
              longitude: snap['longitude']))
        ],
      ),
    );
  }
}

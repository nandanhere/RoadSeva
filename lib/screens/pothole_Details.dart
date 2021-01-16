import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:road_seva/helpers/location_helper.dart';

class PotholeDetails extends StatelessWidget {
  static const String routeName = "/pothole_details";
  const PotholeDetails({Key key}) : super(key: key);

  Future<String> getUrl(DocumentSnapshot snap) async {
    String id = snap['id'];
    final reference =
        FirebaseStorage.instance.ref().child('potholes').child('$id.jpg');
    final s = await reference.getDownloadURL();
    return s;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    DocumentSnapshot snap = args['document'];
    if (snap['hasImage']) {
      return Scaffold(
        appBar: AppBar(
          title: Text(args['title']),
        ),
        body: Column(
          children: [
            FutureBuilder(
              builder: (c, s) {
                return Image.network(s.data);
              },
              future: getUrl(snap),
            ),
            Image.network(LocationHelper.generateLocationMapImage(
                height: size.height - 200,
                latitude: snap['latitude'],
                width: size.width,
                longitude: snap['longitude']))
          ],
        ),
      );
    }
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

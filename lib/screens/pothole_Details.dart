import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:road_seva/helpers/location_helper.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

  void _launchURL(int n) async {
    final url = n == 0
        ? "tel:+1 555 010 999"
        : "https://www.google.com/search?q=Constructors+near+me";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final Map<String, dynamic> args = ModalRoute.of(context).settings.arguments;
    DocumentSnapshot snap = args['document'];
    bool isAdmin = args['isAdmin'];
    if (snap['hasImage']) {
      return Scaffold(
        floatingActionButton:
            SpeedDial(animatedIcon: AnimatedIcons.view_list, children: [
          SpeedDialChild(
            child: Icon(Icons.corporate_fare),
            label: 'Call the area Corporator',
            onTap: () {
              _launchURL(0);
            },
          ),
          SpeedDialChild(
            child: Icon(Icons.construction),
            label: 'Search for nearby Constructors ',
            onTap: () {
              _launchURL(1);
            },
          ),
        ]),
        appBar: AppBar(
          title: Text(args['title']),
          actions: isAdmin
              ? [
                  IconButton(
                      icon: Icon(Icons.done),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('potholes')
                            .doc(snap['id'])
                            .delete();
                        Navigator.of(context).pop();
                      })
                ]
              : [],
        ),
        body: SingleChildScrollView(
          child: Stack(
            children: [
              CachedNetworkImage(
                imageUrl: LocationHelper.generateLocationMapImage(
                    height: size.height * 5 / 6,
                    latitude: snap['latitude'],
                    width: size.width,
                    longitude: snap['longitude']),
                placeholder: (bctx, str) {
                  return CircularProgressIndicator();
                },
              ),
              FutureBuilder(
                builder: (c, s) {
                  if (s.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(top: 10.0, right: 10),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CachedNetworkImage(
                        imageUrl: s.data,
                        placeholder: (bctx, str) {
                          return CircularProgressIndicator();
                        },
                      ),
                    ),
                  );
                },
                future: getUrl(snap),
              ),
            ],
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(args['title']),
        actions: isAdmin
            ? [
                IconButton(
                    icon: Icon(Icons.done),
                    onPressed: () {
                      FirebaseFirestore.instance
                          .collection('potholes')
                          .doc(snap['id'])
                          .delete();
                      Navigator.of(context).pop();
                    })
              ]
            : [],
      ),
      body: Column(
        children: [
          CachedNetworkImage(
            imageUrl: LocationHelper.generateLocationMapImage(
                height: size.height * 5 / 6,
                latitude: snap['latitude'],
                width: size.width,
                longitude: snap['longitude']),
            placeholder: (bctx, str) {
              return Center(child: CircularProgressIndicator());
            },
          )
        ],
      ),
      floatingActionButton:
          SpeedDial(animatedIcon: AnimatedIcons.view_list, children: [
        SpeedDialChild(
          child: Icon(Icons.corporate_fare),
          label: 'Call the area Corporator',
          onTap: () {
            _launchURL(0);
          },
        ),
        SpeedDialChild(
          child: Icon(Icons.construction),
          label: 'Search for nearby Constructors ',
          onTap: () {
            _launchURL(1);
          },
        ),
      ]),
    );
  }
}

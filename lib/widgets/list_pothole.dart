import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_seva/helpers/location_helper.dart';
import 'package:road_seva/screens/pothole_Details.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ListPotHole extends StatefulWidget {
  final bool isAdmin;
  final QueryDocumentSnapshot documentSnapshot;
  ListPotHole({Key key, this.documentSnapshot, this.isAdmin}) : super(key: key);

  @override
  _ListPotHoleState createState() => _ListPotHoleState();
}

class _ListPotHoleState extends State<ListPotHole> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    double lat = widget.documentSnapshot["latitude"],
        long = widget.documentSnapshot["longitude"];
    if (lat == null || long == null) {
      lat = 12.91968822479248;
      long = 77.51994323730469;
    }
    return Container(
      margin: EdgeInsets.only(top: 10, left: 10, right: 10),
      height: height / 3,
      width: width - 10,
      decoration: BoxDecoration(
          color: Color(0xf0f0f0f0),
          boxShadow: [
            BoxShadow(
                color: Colors.white.withOpacity(0.5),
                offset: Offset(-3, -3),
                blurRadius: 3),
            BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(3, 3),
                blurRadius: 3)
          ],
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 10),
              child: Text(
                widget.documentSnapshot["address"].toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_upward,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    var id = FirebaseAuth.instance.currentUser.uid;
                    DocumentReference dr = widget.documentSnapshot.reference;
                    var arr1 = List.from(widget.documentSnapshot["downvoters"]);
                    var arr2 = List.from(widget.documentSnapshot["upvoters"]);
                    if (arr2.contains(id)) {
                      return;
                    }
                    if (arr1.contains(id)) {
                      dr.update({
                        "downvoters": FieldValue.arrayRemove([id])
                      });
                    }
                    dr.update({"upvotes": FieldValue.increment(1)});
                    dr.update({
                      "upvoters": FieldValue.arrayUnion([id])
                    });
                  },
                ),
                Text(
                  (widget.documentSnapshot["upvotes"] -
                          widget.documentSnapshot["downvotes"])
                      .toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                IconButton(
                  icon: Icon(
                    Icons.arrow_downward,
                    color: Colors.black,
                    size: 20,
                  ),
                  onPressed: () {
                    var id = FirebaseAuth.instance.currentUser.uid;
                    DocumentReference dr = widget.documentSnapshot.reference;
                    var arr1 = List.from(widget.documentSnapshot["downvoters"]);
                    var arr2 = List.from(widget.documentSnapshot["upvoters"]);
                    if (arr1.contains(id)) {
                      return;
                    }
                    if (arr2.contains(id)) {
                      dr.update({
                        "upvoters": FieldValue.arrayRemove([id])
                      });
                    }
                    dr.update({"downvotes": FieldValue.increment(1)});
                    dr.update({
                      "downvoters": FieldValue.arrayUnion([id])
                    });
                  },
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, bottom: 5),
              child: IconButton(
                icon: Icon(
                  Icons.message,
                  size: 18,
                ),
                onPressed: () {},
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(
                  PotholeDetails.routeName,
                  arguments: {
                    'document': widget.documentSnapshot,
                    'title': widget.documentSnapshot['address'],
                    'isAdmin': widget.isAdmin,
                  },
                );
              },
              child: Container(
                height: (height ~/ 4).toDouble(),
                width: ((width / 1.3) ~/ 1).toDouble(),
                margin: EdgeInsets.only(bottom: 10, right: 10),
                decoration: BoxDecoration(
                  // color: Colors.pink,
                  image: DecorationImage(
                      image: CachedNetworkImageProvider(
                    LocationHelper.generateLocationPreviewImage(
                        height: height,
                        width: width,
                        latitude: lat,
                        longitude: long),
                  )),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20),
                  ),
                ),
                child: Icon(Icons.location_on, color: Colors.red, size: 25),
                alignment: Alignment.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}

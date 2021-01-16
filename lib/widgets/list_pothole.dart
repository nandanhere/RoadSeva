import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:road_seva/helpers/location_helper.dart';

class ListPotHole extends StatefulWidget {
  final QueryDocumentSnapshot documentSnapshot;
  ListPotHole({Key key, this.documentSnapshot}) : super(key: key);

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
            child: Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_upward,
                    size: 14,
                  ),
                  onPressed: () {},
                ),
                Text("0"),
                IconButton(
                  icon: Icon(
                    Icons.arrow_downward,
                    size: 14,
                  ),
                  onPressed: () {},
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
            child: Container(
              height: (height ~/ 4).toDouble(),
              width: ((width / 1.3) ~/ 1).toDouble(),
              margin: EdgeInsets.only(bottom: 10, right: 10),
              decoration: BoxDecoration(
                // color: Colors.pink,
                image: DecorationImage(
                  image: NetworkImage(
                    LocationHelper.generateLocationPreviewImage(
                        height: height,
                        width: width,
                        latitude: lat,
                        longitude: long),
                  ),
                  fit: BoxFit.fill,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Icon(Icons.location_on, color: Colors.red, size: 25),
              alignment: Alignment.center,
            ),
          )
        ],
      ),
    );
  }
}

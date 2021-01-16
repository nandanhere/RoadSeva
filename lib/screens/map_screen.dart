import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:road_seva/helpers/location_helper.dart';

class MapScreen extends StatefulWidget {
  final List<DocumentSnapshot> potholes;

  final double latitude, longitude;
  final bool isSelecting;

  MapScreen({this.isSelecting, this.latitude, this.longitude, this.potholes});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  File _pickedImage;
  void _pickImage(int value) async {
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.getImage(
        source: value == 0 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50,
        maxWidth: 150);
    final imageFile = File(pickedImage.path);
    setState(() {
      _pickedImage = imageFile;
    });
  }

  LatLng _pickedLocation;
  String address;
  bool _isEnabled = false;
  void _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
      _isEnabled = false;
      address = null;
    });
    try {
      address = await LocationHelper.getPlaceAddress(
          position.latitude, position.longitude);
    } finally {
      if (address != null) {
        setState(() {
          _isEnabled = true;
        });
      }
    }
  }

  void uploadImage(String id) async {
    final reference = FirebaseStorage.instance
        .ref()
        .child('potholes')
        .child('$id.jpg'); // this returns a storage reference in firestore
    await reference.putFile(
        _pickedImage); // this code had .onComplete before. but in newer version of firebaseStorage it is no longer needed.
  }

  @override
  Widget build(BuildContext context) {
    List<Marker> marklist = widget.potholes.map((e) {
      return Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(200),
        flat: true,
        markerId: MarkerId(e['id']),
        position: LatLng(e['latitude'], e['longitude']),
      );
    }).toList();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfff0f0f0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Register a complaint",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          DropdownButton(
            icon: Icon(Icons.photo),
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'camera') {
                _pickImage(0);
              }
              if (itemIdentifier == 'gallery') {
                _pickImage(1);
              }
            },
            items: [
              DropdownMenuItem(child: Text("camera"), value: "camera"),
              DropdownMenuItem(child: Text("camera2"), value: 'gallery')
            ],
          ),
          IconButton(
              padding: EdgeInsets.only(right: 10),
              tooltip: "Open Camera",
              alignment: Alignment.center,
              icon: Icon(
                Icons.camera,
                size: 28,
                color: Colors.black,
              ),
              onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                zoom: 18, target: LatLng(widget.latitude, widget.longitude)),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: (_pickedLocation == null && widget.isSelecting)
                ? {...marklist}
                : {
                    ...marklist,
                    Marker(
                      markerId: MarkerId("m1"),
                      position: _pickedLocation ??
                          LatLng(
                            widget.latitude == null ? 0 : widget.latitude,
                            widget.longitude == null ? 0 : widget.longitude,
                          ),
                    ),
                  },
          ),
          if (_pickedImage != null) Image.file(_pickedImage),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                    color: Colors.red[300],
                    onPressed: !_isEnabled
                        ? null
                        : () {
                            var truth = false;
                            var hasImage = false;
                            String saveid;
                            int upvotes;

                            if (widget.potholes != null)
                              for (DocumentSnapshot element
                                  in widget.potholes) {
                                if (element['address'] == address) {
                                  if (element['hasImage']) {
                                    hasImage = true;
                                  }
                                  truth = true;
                                  saveid = element['id'];
                                  upvotes = element['upvotes'];
                                  break;
                                }
                              }
                            if (truth) {
                              if (hasImage == false && _pickedImage != null) {
                                uploadImage(saveid);
                                hasImage = true;
                              }
                              FirebaseFirestore.instance
                                  .collection('potholes')
                                  .doc(saveid)
                                  .update({
                                'upvotes': upvotes + 1,
                                'hasImage': hasImage
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  duration: Duration(
                                    seconds: 10,
                                  ),
                                  content: Text(
                                      "We have recieved multiple complaints about this road, and we are working on it!"),
                                ),
                              );
                            } else {
                              var id = FirebaseAuth.instance.currentUser.uid;
                              if (_pickedImage == null)
                                hasImage = false;
                              else {
                                hasImage = true;
                                uploadImage(id);
                              }
                              var doc = FirebaseFirestore.instance
                                  .collection('potholes')
                                  .doc();
                              doc.set({
                                'id': doc.id,
                                'isFixed': false,
                                'upvotes': 1,
                                'address': address,
                                'downvotes': 0,
                                'latitude': _pickedLocation.latitude,
                                'longitude': _pickedLocation.longitude,
                                'upvoters': [id],
                                'downvoters': [],
                                "hasImage": hasImage,
                                'timeStamp': Timestamp.now()
                              });
                            }
                            Navigator.of(context).pop();
                          },
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Text(
                      "Report Complaint",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

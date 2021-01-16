import 'dart:io';
import 'package:road_seva/models/place.dart';
import 'package:road_seva/screens/map_screen.dart';
import 'package:road_seva/widgets/place_input.dart';

import 'package:flutter/material.dart';
import 'package:road_seva/widgets/image_input.dart';

import '../models/place.dart';

class ComplaintRegisterScreen extends StatefulWidget {
  static const String routeName = "/complaint-screen";

  ComplaintRegisterScreen({Key key}) : super(key: key);

  @override
  _ComplaintRegisterScreenState createState() =>
      _ComplaintRegisterScreenState();
}

class _ComplaintRegisterScreenState extends State<ComplaintRegisterScreen> {
  File _pickedImage;
  PotHoleDetails _pickedLocation;
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_pickedImage == null) {
      return;
    }

    Navigator.of(context).pop();
  }

  void _selectPlace(double lat, double long) {
    _pickedLocation = PotHoleDetails(latitude: lat, longitude: long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register a complaint"),
      ),
      body: MapScreen(
        latitude: 30.00,
        longitude: 40.00,
        isSelecting: true,
      ),
      // Column(
      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //   crossAxisAlignment: CrossAxisAlignment.stretch,
      //   children: [
      //     Expanded(
      //         child: SingleChildScrollView(
      //       child: Padding(
      //         padding: const EdgeInsets.all(10.0),
      //         child: MapScreen(
      //           latitude: 30.00,
      //           longitude: 40.00,
      //           isSelecting: true,
      //         ),
      //         Column(
      //           children: [
      //             SizedBox(
      //               height: 10,
      //             ),
      //             ImageInput(
      //               onImageSelect: _selectImage,
      //             ),
      //             SizedBox(
      //               height: 10,
      //             ),
      //             LocationInput(
      //               onSelectPlace: _selectPlace,
      //             )
      //           ],
      //         ),
      // ),
      // ),
      // ),\
      // RaisedButton.icon(
      //   elevation: 0,
      //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      //   color: Theme.of(context).accentColor,
      //   icon: Icon(Icons.add),
      //   label: Text("Add Place!"),
      //   onPressed: _savePlace,
      // )
      //   ],
      // ),
    );
  }
}

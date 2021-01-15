import 'dart:io';
import 'package:road_seva/models/place.dart';
import 'package:road_seva/widgets/place_input.dart';

import 'package:flutter/material.dart';
import 'package:road_seva/widgets/image_input.dart';

class ComplaintRegisterScreen extends StatefulWidget {
  static const String routeName = "/complaint-screen";

  ComplaintRegisterScreen({Key key}) : super(key: key);

  @override
  _ComplaintRegisterScreenState createState() =>
      _ComplaintRegisterScreenState();
}

class _ComplaintRegisterScreenState extends State<ComplaintRegisterScreen> {
  final _titleController = TextEditingController();
  File _pickedImage;
  PotHole _pickedLocation;
  void _selectImage(File pickedImage) {
    _pickedImage = pickedImage;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty || _pickedImage == null) {
      return;
    }

    Navigator.of(context).pop();
  }

  void _selectPlace(double lat, double long) {
    _pickedLocation = PotHole(latitude: lat, longitude: long);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a New Place!"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("User Inputs."),
          Expanded(
              child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: "Title",
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  ImageInput(
                    onImageSelect: _selectImage,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  LocationInput(
                    onSelectPlace: _selectPlace,
                  )
                ],
              ),
            ),
          )),
          RaisedButton.icon(
            elevation: 0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            color: Theme.of(context).accentColor,
            icon: Icon(Icons.add),
            label: Text("Add Place!"),
            onPressed: _savePlace,
          )
        ],
      ),
    );
  }
}

import 'dart:convert';
import 'package:road_seva/models/place.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:road_seva/helpers/location_helper.dart';
import 'package:road_seva/screens/map_screen.dart';
import 'package:location/location.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationInput extends StatefulWidget {
  final Function onSelectPlace;
  LocationInput({Key key, this.onSelectPlace}) : super(key: key);

  @override
  _LocationInputState createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl;

  void _showPreview(double lat, double lng) async {
    final imageURL = LocationHelper.generateLocationPreviewImage(
        latitude: lat, longitude: lng);
    final apikey = "AIzaSyAyBrrrsIrOP5z1tz1u1vLtan2l0b__uPI";
    final url1 =
        "https://roads.googleapis.com/v1/nearestRoads?points=$lat,$lng&key=$apikey";
    final response = await http.get(url1);
    final data = jsonDecode(response.body).toString();
    print(data);
    setState(() {
      _previewImageUrl = imageURL;
      print(_previewImageUrl);
    });
  }

  Future<void> _getCurrentUserLocation() async {
    try {
      final locData = await Location().getLocation();
      _showPreview(locData.latitude, locData.longitude);
      widget.onSelectPlace(locData.latitude, locData.longitude);
    } catch (error) {
      print("$error");
    }
  }

  Future<void> _selectOnMap() async {
    final locData = await Location().getLocation();
    LatLng latl = LatLng(locData.latitude, locData.longitude);

    final LatLng selectedLocation = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => MapScreen(
          initialLocation: PotHoleDetails(
              latitude: locData.latitude,
              longitude: locData.longitude,
              address: "",
              url: ""),
          isSelecting: true,
        ),
      ),
    );

    if (selectedLocation == null) {
      return;
    }
    var h = LocationHelper();

    print("hellooooo" + h.getD(selectedLocation, latl).toString());
    _showPreview(selectedLocation.latitude, selectedLocation.longitude);

    widget.onSelectPlace(selectedLocation.latitude, selectedLocation.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              border: Border.all(
            width: 2,
          )),
          height: 170,
          width: double.infinity,
          child: _previewImageUrl == null
              ? Center(
                  child: Text(
                    'No location Chosen!',
                    textAlign: TextAlign.center,
                  ),
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: Icon(Icons.location_on),
              label: Text("Curremt location"),
              textColor: Theme.of(context).primaryColor,
            ),
            FlatButton.icon(
                onPressed: _selectOnMap,
                icon: Icon(Icons.map),
                label: Text("Select on map"))
          ],
        )
      ],
    );
  }
}

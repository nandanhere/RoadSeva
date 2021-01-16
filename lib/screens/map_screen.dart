import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:road_seva/helpers/location_helper.dart';

class MapScreen extends StatefulWidget {
  final double latitude, longitude;
  final bool isSelecting;

  MapScreen({this.isSelecting, this.latitude, this.longitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  String address;
  void _selectLocation(LatLng position) async {
    setState(() {
      _pickedLocation = position;
    });
    address = await LocationHelper.getPlaceAddress(
        position.latitude, position.longitude);
    print(address);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register a complaint"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                zoom: 16, target: LatLng(widget.latitude, widget.longitude)),
            onTap: widget.isSelecting ? _selectLocation : null,
            markers: (_pickedLocation == null && widget.isSelecting)
                ? {}
                : {
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
          Container(
            child: Row(
              children: [
                Image.network(""),
                IconButton(icon: Icon(Icons.camera), onPressed: () {}),
                FlatButton(
                    onPressed: () {
                      FirebaseFirestore.instance.collection('potholes').add({
                        'isFixed': false,
                        'upvotes': 0,
                        'address': address,
                        'downvotes': 0,
                        'latitude': _pickedLocation.latitude,
                        'longitude': _pickedLocation.longitude
                      });
                    },
                    child: Text("Report complaint")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

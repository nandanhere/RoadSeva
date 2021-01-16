import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_seva/models/place.dart';

class MapScreen extends StatefulWidget {
  final double latitude, longitude;
  final bool isSelecting;

  MapScreen({this.isSelecting, this.latitude, this.longitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng _pickedLocation;
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
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
                      LatLng(widget.latitude, widget.longitude)),
            },
    );
  }
}

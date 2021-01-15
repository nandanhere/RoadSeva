import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:road_seva/models/place.dart';

class MapScreen extends StatefulWidget {
  final PotHoleDetails initialLocation;
  final bool isSelecting;

  MapScreen(
      {this.initialLocation =
          const PotHoleDetails(latitude: 37.422, longitude: -122.22),
      this.isSelecting});

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
    return Scaffold(
      appBar: AppBar(title: Text("map"), actions: [
        if (widget.isSelecting)
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _pickedLocation == null
                ? null
                : () => Navigator.of(context).pop(_pickedLocation),
          )
      ]),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
            zoom: 16,
            target: LatLng(widget.initialLocation.latitude,
                widget.initialLocation.longitude)),
        onTap: widget.isSelecting ? _selectLocation : null,
        markers: (_pickedLocation == null && widget.isSelecting)
            ? null
            : {
                Marker(
                    markerId: MarkerId("m1"),
                    position: _pickedLocation ??
                        LatLng(widget.initialLocation.latitude,
                            widget.initialLocation.longitude)),
              },
      ),
    );
  }
}

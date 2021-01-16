import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MapScreen extends StatefulWidget {
  final double latitude, longitude;
  final bool isSelecting;

  MapScreen({this.isSelecting, this.latitude, this.longitude});

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData locData;
  LatLng d = LatLng(0, 0);

  LatLng _pickedLocation;
  void _selectLocation(LatLng position) {
    setState(() {
      _pickedLocation = position;
    });
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
                            LatLng(widget.latitude, widget.longitude)),
                  },
          ),
          Container(
            child: Row(
              children: [
                Image.network(""),
                IconButton(icon: Icon(Icons.camera), onPressed: () {}),
                FlatButton(onPressed: () {}, child: Text("Report complaint")),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

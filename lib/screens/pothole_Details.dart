import 'package:flutter/material.dart';

class PotholeDetails extends StatelessWidget {
  static const String routeName = "/pothole_details";
  const PotholeDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pothole"),
      ),
    );
  }
}

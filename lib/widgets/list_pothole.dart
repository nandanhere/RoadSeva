import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPotHole extends StatefulWidget {
  final QueryDocumentSnapshot documentSnapshot;
  ListPotHole({Key key, this.documentSnapshot}) : super(key: key);

  @override
  _ListPotHoleState createState() => _ListPotHoleState();
}

class _ListPotHoleState extends State<ListPotHole> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child:
          Text(widget.documentSnapshot.id + widget.documentSnapshot["Address"]),
    );
  }
}

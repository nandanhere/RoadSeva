import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:road_seva/helpers/location_helper.dart';
import 'package:road_seva/screens/complaint_register.dart';
import 'package:road_seva/widgets/list_pothole.dart';

class PotHolesNearMe extends StatelessWidget {
  const PotHolesNearMe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Container potHoleList = Container(
      child: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('potholes').snapshots(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          final potholeDoc = snapshot.data.documents;
          return ListView.builder(
              reverse: true,
              shrinkWrap: true,
              itemCount: potholeDoc.length,
              itemBuilder: (ctx, index) {
                QueryDocumentSnapshot potholeData = potholeDoc[index];
                return Container(
                  margin: index == potholeDoc.length - 1
                      ? EdgeInsets.only(top: 20)
                      : null,
                  child: ListPotHole(
                    documentSnapshot: potholeData,
                  ),
                );
              });
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Potholes Near Me",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfff0f0f0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: potHoleList,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.dangerous),
        onPressed: () {
          Navigator.of(context).pushNamed(ComplaintRegisterScreen.routeName);
        },
      ),
    );
  }
}

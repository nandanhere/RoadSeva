import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
          return Center(
            child: ListView.builder(
                reverse: true,
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
                }),
          );
        },
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Road Problems Near me "),
        actions: [
          DropdownButton(
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'Logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            items: [
              DropdownMenuItem(
                value: 'Logout',
                child: Container(
                  child: Row(
                    children: [Icon(Icons.exit_to_app), Text("Logout")],
                  ),
                ),
              ),
            ],
            icon: Icon(Icons.more_horiz),
          )
        ],
      ),
      body: potHoleList,
    );
  }
}

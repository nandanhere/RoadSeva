import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:road_seva/screens/auth_screen.dart';
import 'package:road_seva/screens/complaint_register.dart';
import 'package:road_seva/screens/pothole_Details.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:road_seva/screens/show_all_near_me.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "RoadSeva",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return PotHolesNearMe();
          }
          return AuthScreen();
        },
      ),
      routes: {
        ComplaintRegisterScreen.routeName: (ctx) => ComplaintRegisterScreen(),
        PotholeDetails.routeName: (ctx) => PotholeDetails()
      },
    );
  }
}

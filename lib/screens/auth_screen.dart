import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:road_seva/widgets/auth_form_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final auth = FirebaseAuth.instance;
  var _isLoading = false;
  void _submitAuthForm(String email, String password, String userName,
      bool isLogin, BuildContext ctx, File imageFile) async {
    print("Authentication");

// authResult was named UserCredential
    UserCredential authResult;
    try {
      setState(() {
        _isLoading = true;
      });
      if (isLogin) {
        authResult = await auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(
            email: email, password: password);
        final reference = FirebaseStorage.instance.ref().child('userImages').child(
            '${authResult.user.uid}.jpg'); // this returns a storage reference in firestore
        await reference.putFile(
            imageFile); // this code had .onComplete before. but in newer version of firebaseStorage it is no longer needed.
        FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set({
          'userName': userName,
          'email': email,
          'userId': authResult.user.uid
        });
      }
    } on PlatformException catch (error) {
      setState(() {
        _isLoading = false;
      });
      var message = "Check ur credentials";
      if (error.message != null) {
        message = error.message;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Expanded(
        child: Container(
          height: 1000,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.white,
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColorLight,
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark
              ])),
          child: Stack(children: [
            Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  height: 250,
                  child: Image.asset(
                    "/Users/nandan/apps/udemy_teams_app/udemy_teams_app/assets/amalgam_logo.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Text(
                  "Amalgam",
                  style: TextStyle(fontSize: 50),
                ),
                AuthForm(submitData: _submitAuthForm, isLoading: _isLoading),
              ],
            )
          ]),
        ),
      ),
    ));
  }
}

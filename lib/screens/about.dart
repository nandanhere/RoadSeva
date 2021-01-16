import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = "/about";
  const AboutScreen({Key key}) : super(key: key);
  void _launchURL(int n) async {
    final url = n == 1
        ? "https://www.github.com/TheNova22"
        : "https://www.github.com/nandanhere";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(
          "About",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xfff0f0f0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: Center(
          child: Column(
        children: [
          Container(child: Image.asset("assets/pothole.png")),
          Text("Our Github accounts"),
          FlatButton(
            onPressed: () {
              _launchURL(1);
            },
            child: Text("@theNova22"),
            color: Colors.blue,
          ),
          FlatButton(
            onPressed: () {
              _launchURL(0);
            },
            child: Text("@nandanhere"),
            color: Colors.green,
          ),
          Text("Made with ♥️ using Flutter"),
        ],
      )),
    );
  }
}

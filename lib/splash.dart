import 'dart:async';
import 'package:businesscard/vc/details.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  startTimer() async {
    var duration = Duration(seconds: 3);
    return new Timer(duration, route);
  }

  route() {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => detail()));
  }

  initScreen(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: height / 3,
              width: width / 1.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/docket.gif"),
                ),
              ),
            ),
            SizedBox(
              height: height / 12,
            ),
            Container(
              height: height / 5,
              width: width / 1.5,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/docketbc.gif"),
                ),
              ),
            ),
            SizedBox(
              height: height / 12,
            ),
            Text('Powered by Scanease')
          ],
        )));
  }
}
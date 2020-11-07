import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter/cupertino.dart';
import 'package:printing/printing.dart';

import 'details.dart';

class share extends StatefulWidget {
  final img;
  share({this.img});
  @override
  _shareState createState() => _shareState();
}

class _shareState extends State<share> {
  @override
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    // flutterLocalNotificationsPlugin.initialize(initSettings,
    //     onSelectNotification: onSelectNotification);
  }

  Future _showNotificationWithDefaultSound() async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        'your channel id', 'your channel name', 'your channel description',
        importance: Importance.Max, priority: Priority.High);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      0,
      'Success',
      'Business Card has been downloaded successfully!',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF0E2F44),
        title: Text('Share'),
        actions: <Widget>[
          // GestureDetector(
          //     onTap: () async {
          // var sh = widget.img.readAsBytesSync();
          // await Printing.sharePdf(bytes: sh, filename: 'vc.png');
          //     },
          //     child: Icon(
          //       Icons.share,
          //       size: 30,
          //     )),
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                var sh = widget.img.readAsBytesSync();
                await Printing.sharePdf(bytes: sh, filename: 'vc.png');
              }),
          IconButton(
            icon: Icon(
              Icons.home,
              size: 30,
            ),
            onPressed: () async {
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          child: Center(child: Image.file(widget.img)),
        ),
      ),
    );
  }
}

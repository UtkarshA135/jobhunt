import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:businesscard/vc/share.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class VCview extends StatefulWidget {
  String name;
  String contact;
  String perskill1;
  String perskill2;
  String perskill3;
  String profile;
  String experience;
  String profskill1;
  String profskill2;
  String profskill3;
  String job;
  String education;
  VCview({Key key, @required this.name,@required this.contact,@required this.perskill1,@required this.perskill2,@required this.perskill3,@required this.profile,
    @required this.experience,@required this.profskill1,@required this.profskill2,@required this.profskill3,@required this.job,@required this.education}) : super(key: key);

  @override
  _VCviewState createState() => _VCviewState();
}

class _VCviewState extends State<VCview> {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  initState() {
    super.initState();
    getDocument();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final initSettings = InitializationSettings(android, iOS);

    flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: onSelectNotification);
  }
  var docsPath;
  void getDocument() async {
    var pa = await getExternalStorageDirectory();
    print("Initial Parent Path " +
        pa.path.substring(0, pa.path.indexOf('files')));
    setState(() {
      docsPath = pa.path.substring(0, pa.path.indexOf('files'));
    });
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
  File _imageFile;
  Future onSelectNotification(String payload) async {
    OpenFile.open(_imageFile.path);
  }
  ScreenshotController screenshotController = ScreenshotController();
  @override
  Widget build(BuildContext context) {
    var ht = MediaQuery.of(context).size.height;
    var wt = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('Business Card'),
        actions: <Widget>[
          FlatButton(
              child: new Text("Save"),
              textColor: Colors.white,
              onPressed: () {
                _showNotificationWithDefaultSound();

                _imageFile = null;
                screenshotController
                    .capture(
                    delay: Duration(milliseconds: 500), pixelRatio: 1.5)
                    .then((File image) async {
                  //print("Capture Done");
                  setState(() {
                    _imageFile = image;
                  });
                  var dir = '$docsPath';
                  image.copy(dir +
                      '/' +
                      DateTime.now().millisecondsSinceEpoch.toString() +
                      '.png');
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => share(img: image,)));
                }).catchError((onError) {
                  print(onError);
                });

              }),
        ],
      ),
      body: Screenshot(
        controller: screenshotController,
        child: Container(height: MediaQuery.of(context).size.height ,
          width:MediaQuery.of(context).size.height ,
          child: Center(
              child: Container(height: MediaQuery.of(context).size.height/1.3 ,
                width:MediaQuery.of(context).size.width/1.1 ,
                decoration: BoxDecoration(
                    image: DecorationImage(image: AssetImage('assets/resume.jpeg'),fit: BoxFit.fill)
                ),
                child: Padding(
                    padding:  EdgeInsets.all(ht/200),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding:  EdgeInsets.all(ht/50),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(widget.name,
                                      style: TextStyle(fontSize: 28,color: Colors.white),
                                    ),
                                    Text(widget.job,
                                      style: TextStyle(fontSize: 20,color: Colors.white),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.only(top: ht/4.5,left: 10),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.profskill1,style: TextStyle(fontSize: 11,color: Colors.white),),
                                    Text(widget.profskill2,style: TextStyle(fontSize: 11,color: Colors.white),),
                                    Text(widget.profskill3,style: TextStyle(fontSize: 11,color: Colors.white),),
                                    ],
                                ),

                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: ht/2.9,left: 10),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.perskill1,style: TextStyle(fontSize: 11,color: Colors.white),),
                                    Text(widget.perskill2,style: TextStyle(fontSize: 11,color: Colors.white),),
                                    Text(widget.perskill3,style: TextStyle(fontSize: 11,color: Colors.white),),
                                  ],
                                ),

                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.only(top: ht/2.1,left: 10),
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(widget.contact,style: TextStyle(fontSize: 8,color: Colors.white),),
                                  ],
                                ),

                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:  EdgeInsets.only(left: ht/5.5,top: ht/5.3),
                                child: Text('  '+widget.profile,
                                  style: TextStyle(fontSize: 11,color: Colors.black),),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: ht/5.5,top: ht/3.2),
                                child: Text('  '+widget.experience,
                                  style: TextStyle(fontSize: 11,color: Colors.black),),
                              ),
                            ],
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Column(mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: ht/5.5,top: ht/2),
                                child: Text('  '+widget.education,
                                  style: TextStyle(fontSize: 11,color: Colors.black),),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                ),

              )
          ),
        ),
      ), );


  }
}
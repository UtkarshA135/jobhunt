import 'package:jobhunt/chat/screens/dashboard_screen/dashboard_screen.dart';
import 'package:jobhunt/chatbot.dart';
import 'package:jobhunt/screens/splash.dart';
import 'package:jobhunt/services/firebaseUserProvider.dart';
import 'package:flutter/material.dart';
import 'package:jobhunt/vc/pages/HomePage.dart';
import 'package:provider/provider.dart';
import 'package:wiredash/wiredash.dart';


void main() => runApp(MultiProvider(providers: [
      ChangeNotifierProvider<FirebaseUserProvider>(
          create: (context) => FirebaseUserProvider()),
           
    
    ], child: MyApp()));

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
    final _navigatorKey = GlobalKey<NavigatorState>();
  bool isBuyer = true;
  @override
  void initState() {
    // TODO: implement initState
    Provider.of<FirebaseUserProvider>(context, listen: false)
        .user; //initialising firebaseuserprovider
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
     return Wiredash(
      navigatorKey: _navigatorKey,
      projectId: "demo_show_app-rxf5lpp",
      secret: "p6ju8f33970ly93ipzhwvcnqxsia03bw",
     // translation: MyTranslation(),
      theme: WiredashThemeData(
        primaryColor: Colors.cyan[800],
        secondaryColor: Colors.cyan,
        dividerColor: Colors.black,
        primaryBackgroundColor: Colors.cyan[100],
      ),
    child : MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Job Hunt',
      debugShowCheckedModeBanner: false,
     /* darkTheme: ThemeData(
          brightness: Brightness.dark, primarySwatch: Colors.deepOrange),*/

      home: hp(),
      
      ) );
  }
}
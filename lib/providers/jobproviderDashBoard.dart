import 'package:flutter/material.dart';
import 'package:jobhunt/screens/homescreen.dart';
import 'package:jobhunt/services/authservice.dart';
import 'package:jobhunt/services/googlesignin.dart';
import 'package:shared_preferences/shared_preferences.dart';
class JobProviderHomePage extends StatefulWidget {
  @override
  _JobProviderHomePageState createState() => _JobProviderHomePageState();
}

class _JobProviderHomePageState extends State<JobProviderHomePage> {
   Future<void> resetUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Type', 'None');
  }
  @override
  Widget build(BuildContext context) {
return
         Scaffold(
           appBar: AppBar(title:Text("DashBoard"),
           actions:[
             IconButton(icon: Icon(Icons.thumbs_up_down),onPressed: () async{  await resetUserType();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>HomeScreen()));
             }),
               IconButton(icon: Icon(Icons.exit_to_app),onPressed: () async{  //await resetUserType();
                              AuthService().signOut();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));
             signOutGoogle();
             }),
           ]
           ),
         );
 }
}
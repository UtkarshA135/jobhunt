import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:jobhunt/screens/homescreen.dart';
import 'package:jobhunt/services/authservice.dart';
import 'package:jobhunt/services/googlesignin.dart';




class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = new GlobalKey<FormState>();

  String phoneNo, verificationId, smsCode;

  bool codeSent = false;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
          child: Scaffold(backgroundColor: Colors.black,
              body: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(
                      child: Container(height: height/2.5,width: width/1.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/splash.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: width/8),
                        Text('Enter Your Mobile Number To Proceed',
                          style: TextStyle(color: Colors.white,fontSize: width/22,fontWeight: FontWeight.bold),),
                        Form(
                            key: formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(left: 40,right: 40),
                                  child: Card(
                                    child: TextFormField(
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(hintText: 'Mobile Number',hintStyle: TextStyle(fontWeight: FontWeight.bold),),
                                      initialValue: '+91',
                                      onChanged: (val) {
                                        setState(() {
                                          this.phoneNo = val;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                codeSent ? Padding(
                                    padding: EdgeInsets.only(left: 60.0, right: 60.0),
                                    child: Card(
                                      child: TextFormField(
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(hintText: 'Enter OTP',hintStyle: TextStyle(fontWeight: FontWeight.bold)),
                                        onChanged: (val) {
                                          setState(() {
                                            this.smsCode = val;
                                          });
                                        },
                                      ),
                                    )) : Container(),
                                Padding(
                                    padding: EdgeInsets.only(left: 120.0, right: 120.0),
                                    child: Card(color: Colors.deepOrange,
                                      child: RaisedButton(color: Colors.deepOrange,
                                          child: Center(child: codeSent ? Text('Verify',
                                            style: TextStyle(color: Colors.white,fontSize: width/22),):Text('Get OTP', style: TextStyle(color: Colors.white,fontSize: width/22),)),
                                          onPressed: () {
                                            codeSent ? AuthService().signInWithOTP(smsCode, verificationId):verifyPhone(phoneNo);
                                          }),
                                    ))
                              ],
                            )),SizedBox(height: width/12,),
                        Text('Or Sign In With',
                          style: TextStyle(color: Colors.white,fontSize: width/22,fontWeight: FontWeight.bold),),
                        SizedBox(height: width/30,),
                        _signInButton(),
                      ],
                    ),
                  )
                ],
              )
          )
      ),
    );
  }


  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {
        signInWithGoogle().whenComplete(() {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => HomeScreen(),
            ),
          );
        });
      },
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(image: AssetImage('assets/google.jpg',),height: 30,width: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Google',
                style: TextStyle(
                    fontSize: 23,
                    color: Colors.white,
                    fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}

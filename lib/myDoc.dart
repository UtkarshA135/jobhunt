import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';



class MyDoc extends StatefulWidget {
  @override
  _MyDoc createState() => _MyDoc();
}

bool dialVisible = true;

class _MyDoc extends State<MyDoc> {
  ScrollController scrollController;


  Widget uicard(text, icon) {
    return Card(color: Colors.black45,
      child: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon,color: Colors.white,),
          Text(text,textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold,
              color:Colors.white,),),

        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }


  @override

  String link;
  TextEditingController filename = TextEditingController();




  Widget build(BuildContext context) {

      return Scaffold(
          appBar: AppBar(
            title: Text('Vision Document Scanner'),
          ),
          body: Center(
            child: new Container(
                padding: EdgeInsets.only(bottom: 60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image(image: AssetImage('assets/undraw_blank_canvas_3rbb.png'),)
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('NO DOCUMENTS SCANNED.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 20.0, fontFamily: "Berkshire Swash")),
                    ),
                  ],
                )),
          ),
        );


    }
  }





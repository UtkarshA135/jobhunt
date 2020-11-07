import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:businesscard/vc/vc_view.dart';

class detail extends StatefulWidget {
  @override
  _detailState createState() => _detailState();
}

class _detailState extends State<detail> {



  TextEditingController name = TextEditingController();
  TextEditingController job = TextEditingController();
  TextEditingController profskill1 = TextEditingController();
  TextEditingController profskill2 = TextEditingController();
  TextEditingController profskill3 = TextEditingController();
  TextEditingController perskill1 = TextEditingController();
  TextEditingController perskill2 = TextEditingController();
  TextEditingController perskill3 = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController profile = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController education = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(title: Text('Details'),
        actions: <Widget>[

          IconButton(icon: Icon(Icons.done),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VCview(name: name.text,contact: contact.text,profskill1: profskill1.text,profskill2: profskill2.text,profskill3: profskill3.text,
                        perskill1: perskill1.text,perskill2: perskill2.text,perskill3: perskill3.text,profile: profile.text,experience: experience.text,job: job.text,education: education.text,)));

            },)
        ],),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Center(child: Text('Enter your details',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)),
            SizedBox(height: MediaQuery.of(context).size.height/20,),
            TextField(
              maxLength: 25,
              controller: name,
              decoration: InputDecoration(hintText: 'Name'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 25,
              controller: job,
              style: TextStyle(fontSize: 15),
              decoration: InputDecoration(hintText: 'Job Domain'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 40,
              controller: profskill1,
              decoration: InputDecoration(hintText: 'Proffesional Skill1'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 40,
              controller: profskill2,
              decoration: InputDecoration(hintText: 'Proffesional Skill2'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 40,
              controller: profskill3,
              decoration: InputDecoration(hintText: 'Proffesional Skill3'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 40,
              controller: perskill1,
              decoration: InputDecoration(hintText: 'Personal Skill1'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 40,
              controller: perskill2,
              decoration: InputDecoration(hintText: 'Personal Skill2'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 40,
              controller: perskill3,
              decoration: InputDecoration(hintText: 'Personal Skill3'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 40,
              controller: contact,
              decoration: InputDecoration(hintText: 'Contact'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 80,
              controller: profile,
              decoration: InputDecoration(hintText: 'Profile'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 80,
              controller: experience,
              decoration: InputDecoration(hintText: 'Experience'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
            TextField(
              maxLength: 80,
              controller: education,
              decoration: InputDecoration(hintText: 'Education'),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
          ],
        ),
      ),
    );
  }
}
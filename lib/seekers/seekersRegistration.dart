import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jobhunt/services/authservice.dart';
import 'package:jobhunt/services/googlesignin.dart';
import 'package:jobhunt/screens/homescreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SeekerRegistration extends StatefulWidget {
  @override
  _SeekerRegistrationState createState() => _SeekerRegistrationState();
}

class _SeekerRegistrationState extends State<SeekerRegistration> {

   Future<void> resetUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Type', 'None');
  }
  @override
  Widget build(BuildContext context) {
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

  submitDetails() {
    List<String> professionalSkills = [
      profskill1.text,
      profskill2.text,
      profskill3.text
    ];

    List<String> personalSkills = [
      perskill1.text,
      perskill2.text,
      perskill3.text
    ];
    Firestore.instance.collection("seekers").document(googleSignIn.currentUser.id).updateData({
      "name": name.text,
      "job": job.text,
      "profSkillSet": professionalSkills,
      "perSkillSet": personalSkills,
      "contact": contact.text,
      "profile": profile.text,
      "exp": experience.text,
      "edu": education.text
    });
  }
      String city_preferance = "";
  List<String> city = [
    'Delhi',
    'Mumbai',
    'Bengaluru',
    'Hyderabad',
    'Indore',
    'Lucknow',
    'Jhansi',
    'Kochin',
    'DehraDun',
    'Ranchi',
    'Ujjain',
    'Agartala',
    'Gandhinagar',
    'Chennai',
    'Kolkata',
    'Pune',
    'Nagpur',
    'Jaipur',
    'Bhopal',
    'Ahemdabad',
    'Kanpur',
    'Jabalpur',
    'Patna',
    'Agra',
    'Meerut',
    'Baroda',
    'Koorg',
    'Nasik',
    'Prayagraj',
    'Varanasi',
    'Gurgaon',
    'Srinagar',
    'Jammu',
    'Itanagar',
    'Gangtok',
    'Panaji',
    'Mysore'
  ];
  //gets the current user location and uploads it to the cloud firestore in user's account
  getUserLocation() async {
    Position position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';
    print(completeAddress);
    String formattedAddress = "${placemark.locality}";
    setState(() {
      city_preferance = formattedAddress;
    });
    //  seekerRef
    // .document(googleSignIn.currentUser.id)
    // .updateData({"cityPref": city_preferance});
     //now navigate to the next screen
  }
  return
         Scaffold(
           appBar: AppBar(title:Text("DashBoard"),
           actions:[
             IconButton(icon: Icon(Icons.exit_to_app),onPressed: () async{  //await resetUserType();
                              AuthService().signOut();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));
             signOutGoogle();
             }),
            IconButton(icon: Icon(Icons.thumbs_up_down),onPressed: () async{  //await resetUserType();
                             await resetUserType();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>HomeScreen()));
             }),
           ]
           ),
           body: PageView(
  children: <Widget>[
    Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("What type of jobs are you looking for?",style: TextStyle(
              fontSize: 18.0,
              color: Colors.black
            ),),
            leading: (Icon(Icons.arrow_back,color: Colors.black,)),
          ),
        
        body: GridView.count(crossAxisCount: 2,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        children: <Widget>[
        
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shape: RoundedRectangleBorder(
            
    borderRadius: BorderRadius.circular(15.0),
  ),
            elevation: 5.0,
            shadowColor: Colors.grey,
            color: Colors.white,
            child: Stack(
              children: <Widget>[
                Center(
                  child: Image(image: AssetImage("assets/cooking.jpg"),height: 140.0,)
                ),
                Container(
                  
                  margin: EdgeInsets.only(top: 140,left:60),
                  child: Text(
                    'Cooking',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,
                    fontSize: 18.0,
                    
                    fontWeight: FontWeight.bold),
                    ),
                )
              ],
            ),
          ),
        ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              shadowColor: Colors.grey,
              elevation: 5.0,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child:  Image(image: AssetImage("assets/design.jpeg"),height: 80.0,)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:60),
                    child: Text('Design',style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              elevation: 5.0,
              shadowColor: Colors.grey,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child:  Image(image: AssetImage("assets/driving.jpg"),height: 80.0,)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:60),
                    child: Text('Driving',style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              elevation: 5.0,
              shadowColor: Colors.grey,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child:  Image(image: AssetImage("assets/speak to clients.jpg"),height: 80.0,),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:60),
                    child: Text('Clients',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              elevation: 5.0,
              shadowColor: Colors.grey,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child:  Image(image: AssetImage("assets/manual work.jpg"),height: 80.0,)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:60),
                    child: Text('Manual\nWork',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              elevation: 5.0,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child:  Image(image: AssetImage("assets/work with it.png"),height: 100.0,)
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:50),
                    child: Text('Work With\n IT',textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              elevation: 5.0,
              shadowColor: Colors.grey,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image(image: AssetImage("assets/management.png"),height: 80.0,) ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:50),
                    child: Text("Management",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 5.0,
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              shadowColor: Colors.grey,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image(image: AssetImage("assets/research.jpg"),height: 80.0,) ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:50),
                    child: Text("Research & \n Analysis",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              elevation: 5.0,
              shadowColor: Colors.grey,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image(image: AssetImage("assets/customer-service.jpg"),height: 80.0,) ),
                  Container(
                    margin: EdgeInsets.only(top: 130,left:50),
                    child: Text("Serve \n Customers",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(15.0),
  ),
              elevation: 5.0,
              shadowColor: Colors.grey,
              color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Center(
                    child: Image(image: AssetImage("assets/adminstrative.png"),height: 90.0,) ),
                  Container(
                    margin: EdgeInsets.only(top: 140,left:40),
                    child: Text("Adminstrative \n Work",textAlign: TextAlign.center,style: TextStyle(color: Colors.black,fontSize: 18.0,fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),
          )
        ],
        )
        ),
    
  SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              'Where would you like to work?',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 20,
            ),
            RaisedButton.icon(
              label: Text("Use Current Location",
                  style: TextStyle(color: Colors.green)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              onPressed: () =>getUserLocation(),
              icon: Icon(
                Icons.my_location,
                color: Colors.green,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.separated(
                  separatorBuilder: (context, index) => Divider(
                        height: 1,
                        color: Colors.white,
                      ),
                  itemCount: city.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(3),
                        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                        leading: Icon(
                          Icons.location_city,
                          color: Colors.green,
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.green,
                          ),
                          onPressed: () {
                            //as soon as save info is pressed the preferred city will be updated in the cloud firestore database.
                            // seekerRef
                            //     .document(googleSignIn.currentUser.id)
                            //     .updateData({"cityPref": city[index]});
                            //navigate to the next screeen
                          },
                        ),
                   //     tileColor: Colors.grey[200],
                        hoverColor: Colors.green,
                        title: Text(
                          city[index],
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    );
                  }),
            )
          ],
        ),
      ),
  ),
 Scaffold(
      appBar: AppBar(
        title: Text('Details'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.done),
            onPressed: () {
             /* Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VCview(
                            name: name.text,
                            contact: contact.text,
                            profskill1: profskill1.text,
                            profskill2: profskill2.text,
                            profskill3: profskill3.text,
                            perskill1: perskill1.text,
                            perskill2: perskill2.text,
                            perskill3: perskill3.text,
                            profile: profile.text,
                            experience: experience.text,
                            job: job.text,
                            education: education.text,
                          )));*/
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            Center(
                child: Text(
              'Enter your details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            SizedBox(
              height: MediaQuery.of(context).size.height / 20,
            ),
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
            RaisedButton(
                child: Text('Save Info'),
                onPressed: () {
                  submitDetails();
                })
          ],
        ),
      ),
    )
  
  
  ],
),
         );
  }
}
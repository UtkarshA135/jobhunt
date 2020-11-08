import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobhunt/providers/jobproviderinfo.dart';
import 'package:jobhunt/screens/homescreen.dart';
import 'package:jobhunt/services/authservice.dart';
import 'package:jobhunt/services/googlesignin.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'full_screen_image.dart';
import 'package:jobhunt/models/jobListingModel.dart';
import 'package:jobhunt/services/jobinfoprovider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:multi_media_picker/multi_media_picker.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class ItemCatalog extends StatefulWidget {
   final String itemName;
  final bool isAdded;
  final double price;
  
  final int categoryId;
   ItemCatalog({
    Key key,
    this.itemName='Enter a dish',
    // @required this.refresh,
    this.isAdded=false,
    this.price=0.0,
    this.categoryId=1,
  }) : super(key: key);



  @override

  _ItemCatalogState createState() => _ItemCatalogState();
}

class _ItemCatalogState extends State<ItemCatalog>  {
  bool isAdded;
   double price;
   String url;
  String itemnName;
  String location;
  String skils;

   TextEditingController _priceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
   TextEditingController _locationController = TextEditingController();
     TextEditingController _skillController = TextEditingController();
  String storeId;
  String collectionName;
  
  File _image;
  FirebaseUser current;
  List imgs;
  Future<void> resetUserType() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('User Type', 'None');
  }
  @override
  void initState() { 
    super.initState();
   _getUser();
    this.isAdded = widget.isAdded;
    this.price = widget.price;
    this.itemnName =widget.itemName;
  }
    _getUser()async{
  }

     
      
 
   
_onImageButtonPressed(ImageSource source, {bool singleImage = true}) async {
    
    imgs = await MultiMediaPicker.pickImages(source: source, singleImage: singleImage);
    
    setState(() {
      _image = imgs[0];
    });}
 Future<String> upload() async {
final StorageReference postImgref = FirebaseStorage.instance.ref().child('Post Images');
var timeKey = new DateTime.now();
final StorageUploadTask uploadTask = postImgref.child(timeKey.toString()+'.jpg').putFile(_image);
var imgurl = await(await uploadTask.onComplete).ref.getDownloadURL();
url = imgurl.toString();
print(url);
  return url;
 
}

  @override
  Widget build(BuildContext context) {

      
  return new Scaffold(
      appBar : AppBar(title : Text("Add Job Openings ",),
      centerTitle: true,backgroundColor: Colors.blue[800],
      actions: [
            IconButton(icon: Icon(Icons.exit_to_app),onPressed: () async{  //await resetUserType();
                              AuthService().signOut();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=> AuthService().handleAuth()));
             signOutGoogle();
             }),
            IconButton(icon: Icon(Icons.thumbs_up_down),onPressed: () async{  //await resetUserType();
                             await resetUserType();
                          Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context)=>HomeScreen()));
             }),
      ],
      ),
      
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue[800],
        child:  Icon( Icons.add),
        onPressed:(){ showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(22),
            child: AlertDialog(

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Text('Enter your Job Opening'),
              content: ListView(children: <Widget>[
               GestureDetector(child: CircleAvatar(backgroundImage: url!=null?NetworkImage(url):AssetImage("assets/bamboo.jpg"),
               radius: 100,),
               onTap:()  {    _onImageButtonPressed(ImageSource.gallery);}
               ),
               SizedBox(height:5.0),
                 
                 TextField(

                controller: _nameController,
                decoration: InputDecoration(hintText: "Enter role or work"),
                 ),
                TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                controller: _priceController,
                decoration: InputDecoration(hintText: "Basic pay"),),
                                 TextField(

                controller: _locationController,
                decoration: InputDecoration(hintText: "Enter Job location name"),
                 ),
                 TextField(

                controller: _skillController,
                decoration: InputDecoration(hintText: "Enter skills required"),
                 ),

             
            ]),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {

                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Add Item to Store',style: TextStyle(color: Colors.green),),
                  onPressed: () async {
                    double price = _priceController.text==""?0.0 : double.parse(_priceController.text);
                    String itemName = _nameController.text == null?"Enter a dish":_nameController.text;
                    String picurl = await upload();
                    String location = _locationController.text==""?"Enter job location":_locationController.text;
                    String skills = _skillController.text==""?"Enter job location":_skillController.text;
                   // url!=null?url:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU";
                    // url!=null?url:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU";
                    Provider.of<SellerDetailsProvider>(context,listen: false).addToAvailableItems(itemListingModel:  ItemListingModel(price, itemName,picurl,location,skills),category: widget.categoryId);
                    setState(() {
                      this.isAdded=true;
                      this.itemnName = itemName;
                    this.price =price;
                    this.url =url;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });}),
    body :   StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('jobProviders').document("qV82MrTnkogOUXiJZNxoRsH1ECw2").collection('Openings').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
             
            return snapshot.data.documents.length !=0?
             Dismissible(
               onDismissed: (direction){
 Provider.of<SellerDetailsProvider>(context,listen: false).removeAvailableItem(itemListingModel:  ItemListingModel(documentSnapshot['price'], documentSnapshot['itemName'],documentSnapshot['url'],documentSnapshot['location'],documentSnapshot['skills']),category: widget.categoryId);
        setState(() {
          this.isAdded=false;
          this.price =0.0;
          this.itemnName ='Enter a Dish';
          this.url = null;
        });
               },
               key: Key(documentSnapshot.data['itemName']),
               child: 
              Card(
                elevation :4.0,
                margin : EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius : BorderRadius.circular(8)
                ),
   child:
              
     ListTile(
       leading: CircleAvatar(
            child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: documentSnapshot['url'],)));
                            }),),
         backgroundImage:documentSnapshot['url']!=null? NetworkImage(documentSnapshot['url']):AssetImage("assets/bamboo.jpg"),
         radius: 30.0,
       ),
      title:
      Text(documentSnapshot['itemName']),
      subtitle :Text('\u20B9 ${documentSnapshot['price']}'),
     
     
      trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
       
       Provider.of<SellerDetailsProvider>(context,listen: false).removeAvailableItem(itemListingModel:  ItemListingModel(documentSnapshot['price'], documentSnapshot['itemName'],documentSnapshot['url'],documentSnapshot['location'],documentSnapshot['skills']),category: widget.categoryId);
        setState(() {
          this.isAdded=false;
          this.price =0.0;
          this.itemnName ='Enter a Dish';
          this.url = null;
        });
      },),
    )
    

    )):
        Center(
child: Text("Add Items"),
      
    );
    });
        }));
  
}
/*class ItemCatalogSelectionTile extends StatefulWidget {

  final String itemName;
  final bool isAdded;
  final double price;
  final int categoryId;
   ItemCatalogSelectionTile({
    Key key,
    this.itemName='Enter a dish',
    // @required this.refresh,
    this.isAdded=false,
    this.price=0.0,
    this.categoryId=1,
  }) : super(key: key);

  @override
  _ItemCatalogSelectionTileState createState() => _ItemCatalogSelectionTileState();
}

class _ItemCatalogSelectionTileState extends State<ItemCatalogSelectionTile> with AutomaticKeepAliveClientMixin{
  TextEditingController _priceController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  bool isAdded;
  double price;
  String itemnName;
  String storeId;
  String collectionName;
  String url;
  File _image;
  String current='';
  List imgs;
  @override
  void initState() { 
    super.initState();
    getUser().then((value) => {
      current=value.uid
    });
    this.isAdded = widget.isAdded;
    this.price = widget.price;
    this.itemnName =widget.itemName;
   
_onImageButtonPressed(ImageSource source, {bool singleImage = true}) async {
    
    imgs = await MultiMediaPicker.pickImages(source: source, singleImage: singleImage);
    
    setState(() {
      _image = imgs[0];
    });}
 Future<String> upload() async {
final StorageReference postImgref = FirebaseStorage.instance.ref().child('Post Images');
var timeKey = new DateTime.now();
final StorageUploadTask uploadTask = postImgref.child(timeKey.toString()+'.jpg').putFile(_image);
var imgurl = await(await uploadTask.onComplete).ref.getDownloadURL();
url = imgurl.toString();
print(url);
  return url;
 
}

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    
/* Future  getImage() async {
 // ignore: deprecated_member_use
  try {
          final pickedFile = await _picker.getImage(
            source: ImageSource.gallery,
            
          );
          setState(() {
            _image = File(pickedFile.path);
          });
        } catch (e) {
          setState(() {
            _pickImageError = e;
          });
        }*/
      
 

    return Scaffold(
      appBar : AppBar(title : Text("Add CraftsWork ",),
      centerTitle: true,backgroundColor: Colors.blue[800],
      ),
      floatingActionButton: FloatingActionButton(backgroundColor: Colors.blue[800],
        child:  Icon( Icons.add),
        onPressed:(){ showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: AlertDialog(

              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              title: Text('Enter your Handicraft Product'),
              content: ListView(children: <Widget>[
               GestureDetector(child: CircleAvatar(backgroundImage: url!=null?NetworkImage(url):AssetImage("assets/bamboo.jpg"),
               radius: 100,),
               onTap:()  {    _onImageButtonPressed(ImageSource.gallery);}
               ),
               SizedBox(height:5.0),
                 
                 TextField(

                controller: _nameController,
                decoration: InputDecoration(hintText: "Enter product name"),
                 ),
                TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true,signed: false),
                controller: _priceController,
                decoration: InputDecoration(hintText: "\u20B9 100.00"),
              ),]),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Cancel'),
                  onPressed: () {

                    Navigator.of(context).pop();
                  },
                ),
                new FlatButton(
                  child: new Text('Add Item to Store',style: TextStyle(color: Colors.green),),
                  onPressed: () async {
                    double price = _priceController.text==""?0.0 : double.parse(_priceController.text);
                    String itemName = _nameController.text == null?"Enter a dish":_nameController.text;
                    String picurl = await upload();
                   // url!=null?url:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU";
                    // url!=null?url:"https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQge3zH1vQU2BtGQLBTEeyYY7oY15AXTufAT1EbnKZqbooIfsjI&usqp=CAU";
                    Provider.of<SellerDetailsProvider>(context,listen: false).addToAvailableItems(itemListingModel:  ItemListingModel(price, itemName,picurl),category: widget.categoryId);
                    setState(() {
                      this.isAdded=true;
                      this.itemnName = itemName;
                    this.price =price;
                    this.url =url;
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
          );
        });}),
    body :   StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('jobProviders').document(current).collection('Openings').snapshots(),
        builder: (context, snapshot) {
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,index){
              DocumentSnapshot documentSnapshot = snapshot.data.documents[index];
             return
             snapshot.data.documents.length !=0?
             Dismissible(
               onDismissed: (direction){
 Provider.of<SellerDetailsProvider>(context,listen: false).removeAvailableItem(itemListingModel:  ItemListingModel(documentSnapshot['price'], documentSnapshot['itemName'],documentSnapshot['url']),category: widget.categoryId);
        setState(() {
          this.isAdded=false;
          this.price =0.0;
          this.itemnName ='Enter a Dish';
          this.url = null;
        });
               },
               key: Key(documentSnapshot.data['itemName']),
               child: 
              Card(
                elevation :4.0,
                margin : EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius : BorderRadius.circular(8)
                ),
   child:
              
     ListTile(
       leading: CircleAvatar(
            child: InkWell(
                            onTap: (() {
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => FullScreenImage(photoUrl: documentSnapshot['url'],)));
                            }),),
         backgroundImage:documentSnapshot['url']!=null? NetworkImage(documentSnapshot['url']):AssetImage("assets/bamboo.jpg"),
         radius: 30.0,
       ),
      title:
      Text(documentSnapshot['itemName']),
      subtitle :Text('\u20B9 ${documentSnapshot['price']}'),
     
     
      trailing: IconButton(icon: Icon(Icons.delete),onPressed: (){
       
       Provider.of<SellerDetailsProvider>(context,listen: false).removeAvailableItem(itemListingModel:  ItemListingModel(documentSnapshot['price'], documentSnapshot['itemName'],documentSnapshot['url']),category: widget.categoryId);
        setState(() {
          this.isAdded=false;
          this.price =0.0;
          this.itemnName ='Enter a Dish';
          this.url = null;
        });
      },),
    )
    

    )):
        Center(
child: Text("Add Items"),
      
    );
    });
        }));*/
}
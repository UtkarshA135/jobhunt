import 'dart:async';
import 'package:jobhunt/models/jobListingModel.dart';
import 'package:jobhunt/providers/jobprovider.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jobhunt/providers/jobproviderinfo.dart';

class SellerDetailsProvider extends ChangeNotifier {
  bool isDataLoaded = false;
  Stream<QuerySnapshot> ordersStream,availableItemStream;
  FirebaseUser user;
  Seller seller;
//  Store store;

  SellerDetailsProvider(){ 
    init();
  }


  init()async{
   
    await _getUser();
    await _initUserDetails();
    _initOrdersStream();

    isDataLoaded= true;
    notifyListeners();
  }

  _initUserDetails()async{
    var userDetails = (await Firestore.instance.collection('jobProviders').document(user.uid).get()).data;
   // var storeDetails = (await Firestore.instance.collection('stores').document(userDetails['storeId']).get()).data;

     this.seller = Seller(
      name: userDetails['name'],
      web: userDetails['web'],
      phno1: userDetails['phno1'],
  //    storeId: userDetails['storeId'],
      uid: userDetails['uid'],

    );
   /* this.store = Store(
      location: List<double>.from( storeDetails['location']),
      description: storeDetails['description'],
      id: storeDetails['id'],
      name:storeDetails['name'],
      contact: storeDetails['phno'],
      
    ); */

  }

  _initOrdersStream(){
    ordersStream = Firestore.instance.collection('jobProviders').document("qV82MrTnkogOUXiJZNxoRsH1ECw2").collection('orders').snapshots();
  }
  _getUser()async{
    user = await FirebaseAuth.instance.currentUser();}

  getAvailableItemStream(int category){
    String storeId = this.seller.storeId;
    availableItemStream = Firestore.instance.collection('jobProviders').document("qV82MrTnkogOUXiJZNxoRsH1ECw2").collection("Openings").snapshots();
    //print(getCollectionNameFromCategory(category: category));
    return availableItemStream;
  }

  

  
  
  addToAvailableItems({ItemListingModel itemListingModel,int category}){

        Firestore.instance.collection('jobProviders').document("qV82MrTnkogOUXiJZNxoRsH1ECw2").collection("Openings").add({
      'itemName':itemListingModel.itemName,
      'price':itemListingModel.itemPrice,
      'url':itemListingModel.url,
      'location':itemListingModel.location,
      'skills':itemListingModel.skills
    });
    /*
    String collectionName;
    switch(category){
      case 1:collectionName = 'Embroidery';
    break;
      case 2:collectionName = 'Woodwork';
      break;
      case 3: collectionName = 'Pottery';
      break;
      case 4: collectionName = 'Ceramic';
      break;
      case 5:collectionName = 'Terracotta';
      break;
      case 6:collectionName = 'Weaving and Spinning';
      break;
      
      default : collectionName = '';
              break;

    }
     if(collectionName==''){
      print('select from choices 1 to 6');
    }
    
    Firestore.instance.collection('stores').document(seller.storeId).collection(collectionName).add({
      'itemName':itemListingModel.itemName,
      'price':itemListingModel.itemPrice,
      'url':itemListingModel.url
    });
  }
  
  getCollectionNameFromCategory({@required int category}){
    String collectionName;
      switch(category){
        case 1:collectionName = 'Embroidery';
        break;
        case 2:collectionName = 'Woodwork';
        break;
        case 3: collectionName = 'Pottery';
        break;
        case 4: collectionName = 'Ceramic';
        break;
        case 5:collectionName = 'Terracotta';
        break;
        case 6:collectionName = 'Weaving and Spinning';
        break;
        default : collectionName = '';
                break;

      }
       if(collectionName==''){
      print('select from choices 1 to 6');
    }
      return collectionName;
    }*/
  }
  removeAvailableItem({ItemListingModel itemListingModel,int category})async {
    var docs =await Firestore.instance.collection("jobProviders").document(user.uid).collection("Openings")
      .where('itemName',isEqualTo: itemListingModel.itemName).getDocuments();
      
    for (DocumentSnapshot ds in docs.documents){
      ds.reference.delete();
    }
    /*String collectionName;
    switch(category){
      case 1:collectionName = 'Embroidery';
      break;
      case 2:collectionName = 'Woodwork';
      break;
      case 3: collectionName = 'Pottery';
      break;
      case 4: collectionName = 'Ceramic';
      break;
      case 5:collectionName = 'Terracotta';
      break;
      case 6:collectionName = 'Weaving and Spinning';
      break;
      default : collectionName = '';
              break;

    }
   */

  }}

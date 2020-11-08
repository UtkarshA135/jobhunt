import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jobhunt/providers/jobproviderinfo.dart';
import 'package:jobhunt/providers/jobselectionTile.dart';
import 'package:jobhunt/models/jobcatalog.dart';
import 'package:jobhunt/models/jobListingModel.dart';
import 'package:jobhunt/services/jobinfoprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:trie/trie.dart';

class ItemSelectorPage extends StatefulWidget {
  final int sheetsPage;
  // =<ItemListingModel>[ItemListingModel(75.0, 'Banana')];
  ItemSelectorPage({Key key, this.sheetsPage}) : super(key: key);

  @override
  _ItemSelectorPageState createState() =>
      _ItemSelectorPageState(sheetsPage: sheetsPage);
}

class _ItemSelectorPageState extends State<ItemSelectorPage> {
  final int sheetsPage;
   List<ItemListingModel> availableItems = new List();

  bool isLoading = true;
  bool _isSearching =false;
  Trie trieItemsCatalogue = new Trie.list([]);

  String sheetsApiUrl = '';

  List<ItemCatalog> icst = new List();
  List<ItemCatalogModel> itemsCatalogue= new List();
  List<ItemCatalogModel> listItems = new List();
  Icon actionIcon = new Icon(Icons.search);
  Widget appBarTitle = new Text("Item Selector");
  String current = "";
  var _searchQueryController = new TextEditingController();
  _ItemSelectorPageState({
    this.sheetsPage,
  });

  @override
  void initState() {
    super.initState();
  getUser().then((value) { current=value.uid;});
    setState(() {
      this.sheetsApiUrl =
          'https://spreadsheets.google.com/feeds/cells/1d9aQp5C_lqKT6-x8CFu4ACzgqcUSdhBOqE97DAWfXps/$sheetsPage/public/full?alt=json';
    });
    _getlist();
    
  }

  _getlist() async {
    var response = await http.get(sheetsApiUrl);
    var data = jsonDecode(response.body);
    // print(data);
    List<dynamic> items = data['feed']['entry'];
    await _loadAvailableItemsList();
    setState(() {
      this.trieItemsCatalogue = new Trie.list(
        items
          .map((item) => item['content']['\$t'].toString())
          .toList()
          );
      this.itemsCatalogue = items
          .map((item) => ItemCatalogModel.fromJson(item['content']['\$t']))
          .toList();
      this.icst = _listUpdate();
      this.isLoading = false;
    });
    // print(this.itemsCatalogue.length);
    // print(widget.availableItems[0].itemName);
    // _listUpdate();
  }
 
  _loadAvailableItemsList()async{
    var sellerprovider = Provider.of<SellerDetailsProvider>(context,listen: false);
    var snapshot = await Firestore.instance.collection('jobProviders')
    .document("qV82MrTnkogOUXiJZNxoRsH1ECw2")
    .collection('Openings')
    .getDocuments();
    var docs = snapshot.documents;
    List<ItemListingModel> temp = new List();
    
    for(int i=0;i<docs.length;i++){
      temp.add(ItemListingModel(docs[i].data['price'],docs[i].data['itemName'],docs[i].data['url'],docs[i].data['location'],docs[i].data['skils']));
    }
    setState(() {
      this.availableItems = temp;
    });
             
  }

  _searchItems(String searchTerm){
     setState(() {
      this.itemsCatalogue = this.trieItemsCatalogue
      .getAllWordsWithPrefix(searchTerm)
      .map<ItemCatalogModel>((e) => ItemCatalogModel.fromJson(e)).toList();
      
      this.icst = _listUpdate()??[];
      isLoading = false;
    });
  }
 

  _listUpdate() {
    if(itemsCatalogue==null||itemsCatalogue.isEmpty)
    return ;

    Map<String,int> map =new Map();

    List<ItemCatalog> temp = new List();

    for(int i=0;i<this.itemsCatalogue.length;i++){
      map[this.itemsCatalogue[i].itemName] =i;
       temp.add(
          ItemCatalog(
            key: Key(itemsCatalogue[i].itemName),
        isAdded: false,
        itemName: itemsCatalogue[i].itemName,
        price: itemsCatalogue[i].itemPrice,

        ));
    }
    
    
    List<ItemListingModel> av = this.availableItems;

    for(int i=0;i<av.length;i++){
      int foundindex = map[av[i].itemName];
      print("fi $foundindex");
      if(foundindex!=null){

         itemsCatalogue[foundindex].isAdded=true;
         itemsCatalogue[foundindex].itemPrice=this.availableItems[i].itemPrice;
          
          temp[foundindex] = ItemCatalog(
            key: Key(itemsCatalogue[foundindex].itemName),
            isAdded: true,
            itemName: itemsCatalogue[foundindex].itemName,
            price: itemsCatalogue[foundindex].itemPrice,
            );
          }

        }
      return temp??[];
  }

  refresh() {
    setState(() {});
  }
  
  
    

  @override
  Widget build(BuildContext context) {
    return new  Scaffold(
      
      appBar: new AppBar(
        title: appBarTitle,
        actions: <Widget>[
        new IconButton(
          icon: actionIcon,
          onPressed: () {
            setState(() {
              if (this.actionIcon.icon == Icons.search) {
                this.actionIcon = new Icon(Icons.close);
                this.appBarTitle = new TextField(
                  style: new TextStyle(
                    color: Colors.white,
                  ),
                  onChanged: (text) {
                    _searchItems(text);
                  },
                  decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Enter a product name",
                    hintStyle: new TextStyle(color: Colors.white),
                  ),
                );
              } else {
                this.actionIcon = new Icon(Icons.search);
                this.appBarTitle = new Text("Search");
              }
            });
          },
        ),
      ],
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        elevation: 1.0,
      ),
      body: isLoading?Center(child: CircularProgressIndicator(),):
      ListView(
              physics: BouncingScrollPhysics(),
              children: this.icst,
            )

    );
  }
}

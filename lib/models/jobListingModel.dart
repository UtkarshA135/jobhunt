class ItemListingModel {
  final double itemPrice;
  final String itemName;
  final String url;
  final String skills;
  final String location;
  ItemListingModel(
   this.itemPrice,
   this.itemName,
    this.url,
    this.location,
    this.skills
  );

  factory ItemListingModel.fromJson(dynamic json){
  return ItemListingModel(
    
    json['price'] +0.0,
    json['itemName'],
    json['url'],
    json['location'],
    json['skills']
  );
}
}

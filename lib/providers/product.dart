import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier  {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite=false;
  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.imageUrl,
      @required this.price
      ,this.isFavorite=false});


  void setFavoriteValu(bool val ){
    isFavorite=val;
    notifyListeners();

  }

  Future <void> toggleFavoriteStatus() async{
    isFavorite=!isFavorite;
    notifyListeners();

    var url = Uri.parse(
          'https://flutter-app-4e2d2-default-rtdb.firebaseio.com/products/$id.json');


     final response= await http.patch(url,
          body: json.encode({
            'isFavorite': this.isFavorite
          }));
if(response.statusCode>=400){

  setFavoriteValu(!isFavorite);

}



  }
}

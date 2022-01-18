import 'package:flutter/cupertino.dart';
import '../model/http_exception.dart';
import 'product.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> item = [];

  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];

//var showFavoriteOnly=false;
  List<Product> get items {
// if (showFavoriteOnly){
//
//
// }
    return [...item];
  }

  List<Product> get Favorites {
    return item.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return item.firstWhere((element) => element.id == id);
  }

// void showFavoritOnly(){
//   showFavoriteOnly=true;
//   notifyListeners();
// }
//
// void showAll(){
//   showFavoriteOnly=false;
//   notifyListeners();
//
// }

  Future<void> removeSingleItem(String productid) async {
    var url = Uri.parse(
        'https://flutter-app-4e2d2-default-rtdb.firebaseio.com/products/$productid.json');
    final exestingProductIndex =
        item.indexWhere((element) => element.id == productid);
    var exestingProduct = item[exestingProductIndex];
    item.removeAt(exestingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      item.insert(exestingProductIndex, exestingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    exestingProduct = null;
  }

  Future<void> fetchAndSetProducts() async {
    var url = Uri.parse(
        'https://flutter-app-4e2d2-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if(extractedData==null){
        return;
      }
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: double.parse(prodData['price']),
          isFavorite: prodData['isFavorite'],
          imageUrl: prodData['imageUrl'],
        ));
      });
      item = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  //
  // Future<void> fetchAndSetProducts() async {
  //   var url = Uri.parse(
  //       'https://flutter-app-4e2d2-default-rtdb.firebaseio.com/products.json');
  //   try {
  //     final response = await http.get(url);
  //     final extractedData = json.decode(response.body) as Map<String, dynamic>;
  //     final List<Product> LoadedProducts = [];
  //     extractedData.forEach((productId, prodData) {
  //       LoadedProducts.add(Product(
  //           id: productId,
  //           title: prodData['title'],
  //           description: prodData['description'],
  //           imageUrl: prodData['imageUrl'],
  //           price:double.parse(prodData['price']) ,
  //           isFavorite: prodData['isFavorite']));
  //     });
  //     item=item+LoadedProducts;
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  Future<void> addProduct(Product newProduct) async {
    var url = Uri.parse(
        'https://flutter-app-4e2d2-default-rtdb.firebaseio.com/products.json');
    try {
      final value = await http.post(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price.toString(),
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite
          }));

      final product = new Product(
          title: newProduct.title,
          description: newProduct.description,
          imageUrl: newProduct.imageUrl,
          price: newProduct.price,
          id: json.decode(value.body)['name']);
      item.add(product);
      print(json.decode(value.body)['name']);
      notifyListeners();
    } catch (error) {
      throw error;
    }

//  items.add(value);
  }

  Future<void> updateProduct(String productId, Product newProduct) async {
    final prodIndex = item.indexWhere((element) => element.id == productId);
    if (prodIndex >= 0) {
      var url = Uri.parse(
          'https://flutter-app-4e2d2-default-rtdb.firebaseio.com/products/$productId.json');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'description': newProduct.description,
            'price': newProduct.price.toString(),
            'imageUrl': newProduct.imageUrl,
            'isFavorite': newProduct.isFavorite
          }));
      notifyListeners();
    } else {
      print('...');
    }
  }

  Products();
}

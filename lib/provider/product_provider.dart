

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/httpException.dart' ;
import 'dart:convert';
import 'product.dart';
//import 'dart:html';

class Product_Provider with ChangeNotifier
{
  List<Product> _items = [];
  final String token;
  final String userId;

  Product_Provider(this.token,this.userId,this._items);



  List<Product> get items
  {
    return [..._items];
  }
  List<Product> get favItems
  {
    return _items.where((prod)=>prod.isFav == true).toList();
  }
  Product findById(String id)
  {
    return _items.firstWhere((prod)=>prod.id == id);
  }


  Future<void> fetchProduct() async
  {
    var url = 'https://shop-app-6ca2c.firebaseio.com/products.json?auth=$token';
    try
    {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      if(extractedData == null)
      {
        return ;
      }
      url = 'https://shop-app-6ca2c.firebaseio.com/userFav/'+userId+'.json?auth='+token;
      final favResponse = await http.get(url);
      final favData = json.decode(favResponse.body);
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          isFav: favData == null?false:(favData[prodId] == null?false:favData[prodId]),
          imageUrl: prodData['imageUrl'],
          )
        );
        }
      );
      _items = loadedProducts;
      notifyListeners();
    }
    catch(error)
    {
      throw error;
    }

  }

  Future<void> addProduct(Product product) async{
    final url = 'https://shop-app-6ca2c.firebaseio.com/products.json?auth=$token';
    try{
      final response = await http.post(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    }
    catch(error){
      throw error;
    }
  }
 Future<String> deleteProduct(String id)
  {
    var url = 'https://shop-app-6ca2c.firebaseio.com/products/$id.json?auth=$token';
    return http.delete(url).then((response){
      if(response.statusCode >=400)
      {
        throw httpException('Could not delete product');
      }
      _items.removeWhere((item)=>item.id == id);
      url = 'https://shop-app-6ca2c.firebaseio.com/userFav/'+userId+'/$id.json?auth='+token;
      http.delete(url);
      notifyListeners();
      return 'Product deleted';
    }).catchError((error){
      return error.toString();
    });
  }

}
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Product with ChangeNotifier
{
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFav;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFav = false,
  });

  Future<void> alertWid (BuildContext context)  async
  {
    await showDialog<Null>(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(child: Text('Okay'), onPressed: () {
                Navigator.of(ctx).pop();
              },)
            ],
          ),
    );
  }


  Future<void> toggleFav(BuildContext context,String token,String userId) async
  {
    final oldStatus = isFav;
    final url = 'https://shop-app-6ca2c.firebaseio.com/userFav/'+userId+'/$id.json?auth='+token;
    isFav = !isFav;
    notifyListeners();
    try
    {
      final response = await http.put(url, body: json.encode(isFav));
      if(response.statusCode>=400)
      {
        isFav = oldStatus;
        notifyListeners();
        alertWid(context);
      }

    }
    catch(error)
    {
      isFav = oldStatus;
      notifyListeners();
      alertWid(context);

    }
  }

}
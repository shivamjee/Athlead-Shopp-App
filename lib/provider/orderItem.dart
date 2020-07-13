import 'package:flutter/material.dart';
import './cartItem.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class OrderItem
{
  final String id;
  final DateTime date;
  final double amount;
  bool expanded;
  final List<CartItem> products;
  OrderItem({
   @required this.id,
  @required this.date,
  @required this.amount,
  @required this.products,
    this.expanded = false,
});
}

class Orders with ChangeNotifier
{

  final String authToken;
  final String userId;
  List<OrderItem> _orderList = [];

  Orders(this.authToken,this.userId,this._orderList);


  List<OrderItem> get orderList
  {
    return [..._orderList];
  }


  Future<void> fetchOrder() async
  {
    final url = 'https://shop-app-6ca2c.firebaseio.com/orders/$userId.json?auth=$authToken';
    try
    {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String,dynamic>;
      final List<OrderItem> tempList =[];
      if(extractedData == null)
      {
          return;
      }
      extractedData.forEach((id,data)
        {
          tempList.add(
              OrderItem(
                  id: id,
                  date: DateTime.parse(data['date']),
                  amount: data['amount'],   //prodData['title']
                  products: (data['products'] as List<dynamic>).map((items)=>CartItem(
                    id: items['id'],
                    price: items['price'],
                    title: items['title'],
                    quantity: items['quantity'],
                  )).toList(),
              )
          );
        }
      );
      _orderList = tempList.reversed.toList();
      notifyListeners();
    }
    catch(error)
    {
      print(error);
      throw error;
    }
  }
  Future<void> addOrder(double amount, List<CartItem> product) async
  {
    final url = 'https://shop-app-6ca2c.firebaseio.com/orders/$userId.json?auth=$authToken';
    final date = DateTime.now();
    try {
      final response = await http.post(
          url,
          body: json.encode({
            'date': date.toIso8601String(),
            'amount': amount,
            'products': product.map
              ((cp) =>
            {
              'id': cp.id,
              'title': cp.title,
              'price': cp.price,
              'quantity': cp.quantity,
            }
            ).toList(),
          }
          )
      );
      _orderList.insert(0, OrderItem(id: json.decode(response.body)['name'], date: date, amount: amount, products: product));
      notifyListeners();
    }
    catch(error)
    {
      throw error;
    }
  }
}
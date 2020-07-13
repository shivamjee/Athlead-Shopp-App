import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class CartItem
{
  final String id;
  final String title;
  final double price;
  final int quantity;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.price,
    @required this. quantity,

  });

}
List<CartItem> items = [];
class Cart with ChangeNotifier {


  List<CartItem> get item {
    return [...items];
  }


  int get itemCount {
    return item.length;
  }

  double get totalPrice{
    double tp=0;
    for(int i =0;i<items.length;i++)
      tp += ((items[i].price) * (items[i].quantity)) ;
    return tp;
  }
  void addItem(String productId, String title, double price) {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == productId) {
        int qty = items[i].quantity;
        items.removeAt(i);
        items.insert(i, CartItem(
          id: productId,
          title: title,
          price: price,
          quantity: qty + 1,
        ),
        );
        notifyListeners();
        return;
      }
    }
    items.add(
      CartItem(
        id: productId,
        title: title,
        price: price,
        quantity: 1,
      ),
    );
    notifyListeners();
  }
  void removeItem(String id)
  {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        items.removeAt(i);
        notifyListeners();
        return;
      }
    }
  }
  void removeSingleItem(String id)
  {
    for (int i = 0; i < items.length; i++) {
      if (items[i].id == id) {
        if(items[i].quantity == 1)
          removeItem(id);
        else
        {
          int qty = items[i].quantity;
          double price = items[i].price;
          String title = items[i].title;
          items.removeAt(i);
          items.insert(i, CartItem(
            id: id,
            title: title,
            price: price,
            quantity: qty -1,
            ),
          );
        }
      }
    }

  }
  void clearItems()
  {
    items = [];
    notifyListeners();
  }
}
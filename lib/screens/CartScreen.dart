import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orderItem.dart';
import '../provider/cartItem.dart';
import '../widgets/cartProductTile.dart';
class CartScreen extends StatefulWidget
{
  @override
  _CartScreenState createState() => _CartScreenState();
}
bool isLoading = false;
class _CartScreenState extends State<CartScreen> {
  Widget build(BuildContext ctx)
  {
    final cart = Provider.of<Cart>(ctx);
    final cartItems = cart.item;
    final orders = Provider.of<Orders>(ctx,listen: false);
    Future<void> alertWid ()  async
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


    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart"),
      ),
      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          SizedBox(height: 10,),
          Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Theme.of(ctx).primaryColor,
                    ),
                  ),
                  Spacer(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(ctx).primaryColor,
                    ),
                    padding: EdgeInsets.all(5),
                    child: Text(
                      '\$ ${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 4,),
                  FlatButton(
                    onPressed: () async
                    {
                      if(cart.totalPrice != 0 )
                      {
                        setState((){
                          isLoading = true;
                        });
                        try
                        {
                          await orders.addOrder(cart.totalPrice, cartItems);
                          setState((){
                            isLoading = false;
                          });
                          cart.clearItems();
                        }
                        catch(error)
                        {
                          alertWid().then((_)=> setState((){
                            isLoading = false;
                          }));
                        }
                      }
                    },
                    child: isLoading?
                    Center(
                      child: CircularProgressIndicator(),
                    )
                        : Text(
                      "Order Now",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx,i){
                return CartTile(
                  cartItems[i].id,
                  cartItems[i].title,
                  cartItems[i].price,
                  cartItems[i].quantity,
                );
              },
            ),
          )

        ],
      ),
    );
  }
}
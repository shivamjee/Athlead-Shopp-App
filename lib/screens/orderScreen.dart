import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/orderItem.dart';

class OrdersScreen extends StatefulWidget
{
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

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
  var init = true;
  var isLoading = false;
  void didChangeDependencies() {

    if(init)
    {
      setState(() {
        isLoading = true;
      });
      Provider.of<Orders>(context).fetchOrder().then((_){
            setState(() {
              isLoading = false;
            });
          }
      ).catchError((error){
        alertWid().then(
                (_){
              setState(() {
                isLoading = false;
              });
            }
        );
      });
    }
    init = false;
    super.didChangeDependencies();
  }
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    final orderList = orders.orderList;
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Orders"),
      ),

      body: isLoading?
        Center(child: CircularProgressIndicator(),)
        :orderList.isEmpty?
          Center(
            child: Text(
                "No Orders Yet!",
              style: TextStyle(fontSize: 32),
            ),
          )
        :Padding(
        padding: EdgeInsets.all(10),
        child: ListView.builder(
            itemCount: orderList.length,
            itemBuilder: (ctx,i){
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.linear,
                height: orderList[i].expanded ? min(orderList[i].products.length*20.0+110,200):95,
                child: Card(
                  elevation: 7,
                  margin: EdgeInsets.symmetric(horizontal: 7,vertical: 8),
                  child: Column(
                    children:[Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "\$${orderList[i].amount.toStringAsFixed(2)}",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24
                              ),
                            ),
                            Text(
                              orderList[i].date.toString(),
                              style: TextStyle(
                                  fontWeight: FontWeight.w100,
                                  fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: Icon(orderList[i].expanded?Icons.expand_less:Icons.expand_more),
                          onPressed: (){
                            setState(() {
                              orderList[i].expanded = !orderList[i].expanded;
                            });
                          },
                        ),
                      ],
                    ),
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.linear,
                      height: orderList[i].expanded ? min(orderList[i].products.length*20.0+35,100):0,
                      child: Container(
                        height: min(orderList[i].products.length*20.0+50,180),
                        padding: EdgeInsets.all(10),
                        child: ListView.builder(
                            itemCount: orderList[i].products.length,
                            itemBuilder: (ctx,j){
                              final ep = orderList[i].products[j];
                              return Row(
                                children: <Widget>[
                                  Text(
                                    ep.title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    '${ep.quantity}x${ep.price}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w100,
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              );
                            }),
                      ),
                    )
                    ],
                  ),
            ),
              );
          }
        ),
      )
    );
  }
}



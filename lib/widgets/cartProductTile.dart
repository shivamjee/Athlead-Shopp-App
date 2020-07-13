import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cartItem.dart';
class CartTile extends StatelessWidget {

  final String id;
  final String title;
  final double price;
  final int quantity;
  CartTile(this.id,this.title,this.price,this.quantity);

  Widget build(BuildContext ctx)
  {
    final cartData = Provider.of<Cart>(ctx,listen: false);
    return Dismissible(
      key: ValueKey(id),
      background: Container(
        padding: EdgeInsets.all(10),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
        ),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        )
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction){
        return showDialog(
            context: ctx,
            builder:(ctx)=> AlertDialog(
              title: Text('Are you Sure?'),
              content: Text('Do you want to remove the item?'),
              actions: <Widget>[
                FlatButton(
                  child: Text("NO"),
                  onPressed: ()=> Navigator.of(ctx).pop(false),
                ),
                FlatButton(
                  child: Text("YES"),
                  onPressed: ()=> Navigator.of(ctx).pop(true),
                ),
              ],
          )
        );
      },
      onDismissed: (direction){
        cartData.removeItem(id);
      },

      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ) ,
        elevation: 10,
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child:CircleAvatar(
                child: FittedBox(
                  child: Text(
                      '\$${price}',
                  ),
                ),
              ),
            ),
            Column(
              children: <Widget>[
                Text(
                  '${title}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Total \$${price*quantity}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                '${quantity}x'
              ),
            ),
          ],
        ),
      ),
    );
  }
}
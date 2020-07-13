import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Auth_Provider.dart';
import '../provider/product.dart';
import '../provider/cartItem.dart';

class ProductItem extends StatelessWidget
{
  /*final String id;
  final String title;
  final String imgUrl;

  ProductItem(this.id,this.title,this.imgUrl);*/
  final rebuildPage;
  ProductItem(this.rebuildPage);

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

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context,listen: false);
    final auth = Provider.of<AuthProvider>(context,listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: (){
            Navigator.of(context).pushNamed(
              'productDetail',
              arguments: product.id,
            );
          },
          child: Hero(
            tag: product.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/placeHolder.png'),
              image: NetworkImage(product.imageUrl,),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: IconButton(
              icon: Icon(
                product.isFav? Icons.favorite:Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed:()=>product.toggleFav(context,auth.token,auth.userId),
            ),


          title: Text(
              product.title,
            textAlign: TextAlign.center,
            softWrap: true,
            overflow: TextOverflow.fade,
          ),


          trailing: IconButton(
            icon: Icon(
                Icons.shopping_cart,
                color: Colors.red,
            ),
            onPressed: ()
            {
              cart.addItem(
                  product.id,
                  product.title,
                  product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(product.title+' added to cart'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: "UNDO",
                    textColor: Colors.white,
                    onPressed: (){
                      cart.removeSingleItem(product.id);
                      rebuildPage();
                      },
                  ),
                ),
              );
              rebuildPage();
            },
          ),
        ),
      ),
    );
  }
}
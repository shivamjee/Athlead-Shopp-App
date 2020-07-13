import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../provider/product_provider.dart';
import '../widgets/userProductTile.dart';
class UserProductScreen extends StatelessWidget
{

  Future<void> refreshProd(BuildContext context) async
  {
    await Provider.of<Product_Provider>(context).fetchProduct();
  }
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product_Provider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("MyProducts"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: (){
              Navigator.pushNamed(context, 'EditProductScreen');
            },
          )
        ],
      ),
      body:RefreshIndicator(
        onRefresh: ()=> refreshProd(context),
        child: Container(
              padding: EdgeInsets.all(10),
              child: ListView.builder(
                      itemCount: product.items.length,
                      itemBuilder: (context,i) {
                        Divider();
                        return UserProductTile(
                            product.items[i].id,
                            product.items[i].title,
                            product.items[i].imageUrl
                        );
                      }
                  ),
          ),
      ),
      );
  }
}
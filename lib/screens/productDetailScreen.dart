import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class ProductDetailScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct = Provider.of<Product_Provider>(context,listen: false,).findById(productId);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title:Text(
                  loadedProduct.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
              ),
              background: Hero(
                  tag: loadedProduct.id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                    colorBlendMode: BlendMode.color,
                  ),
                ),
              ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10,),
                Center(
                  child: Container(
                      child: Text(
                        loadedProduct.title,
                        style: TextStyle(color: Colors.grey,fontSize: 32,fontWeight: FontWeight.bold),
                      ),
                    ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: Text('\$${loadedProduct.price}',
                      style: TextStyle(fontSize: 20),),
                  ),
                ),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    child: Text(
                      loadedProduct.description,
                      style: TextStyle(color: Colors.black87,fontSize: 16,fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  height: 800,
                )
              ],
            ),
          ),
        ],
      ),

      /*Container(
        width: double.infinity,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 250,
              child: Hero(
                tag: loadedProduct.id,
                child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  colorBlendMode: BlendMode.color,
                ),
              ),
            ),

          ],
        ),
      ),*/
    );
  }
}
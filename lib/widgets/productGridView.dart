import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './productItem.dart';
import '../provider/product_provider.dart';
import '../provider/cartItem.dart';

class ProductGridView extends StatelessWidget
{
  final pageIndex;
  final rebuildPage;
  ProductGridView(this.pageIndex,this.rebuildPage);
  @override
 Widget build(BuildContext ctx)
 {
   final productData = Provider.of<Product_Provider>(ctx);
   final productList = (pageIndex==0) ? productData.items:productData.favItems;
   return GridView.builder(
       padding: const EdgeInsets.all(10),
       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
         crossAxisCount: 2,
         childAspectRatio: 3/2,
         crossAxisSpacing: 10,
         mainAxisSpacing: 10,
       ),
       itemBuilder: (ctx,index){
         return MultiProvider(
           providers: [
             ChangeNotifierProvider.value(
               value: productList[index],
             ),
             ChangeNotifierProvider.value(
               value: Cart(),
             ),
           ],
           child: ProductItem(rebuildPage),
         );
       },
       itemCount: productList.length,
   );
 }
}
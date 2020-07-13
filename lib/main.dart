import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/Auth_Provider.dart';
import './provider/cartItem.dart';
import './provider/orderItem.dart';
import './screens/AuthScreen.dart';
import './screens/editProductScreen.dart';
import './screens/userProductScreen.dart';
import './screens/orderScreen.dart';
import './screens/productOverviewGridScreen.dart';
import './screens/productDetailScreen.dart';
import './screens/CartScreen.dart';
import './provider/product_provider.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => AuthProvider(),
        ),
        ChangeNotifierProxyProvider<AuthProvider,Product_Provider>(
          builder: (ctx,auth,prevProvider) => Product_Provider(
            auth.token,
            auth.userId,
            (prevProvider == null)?[]:prevProvider.items,
          ),
        ),
        ChangeNotifierProvider(
          builder: (_) => Cart(),
        ),
        ChangeNotifierProxyProvider<AuthProvider,Orders>(
          builder: (ctx,auth,prevOrder) => Orders(
              auth.token,
              auth.userId,
              prevOrder == null?[]:prevOrder.orderList
          ),
        )
      ],

      child: Consumer<AuthProvider>(
        builder:(context,auth,_)=>MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
              primaryColor: Colors.blue[900],
              accentColor: Colors.black,
              fontFamily: 'Lato',
            ),
            routes: {
              '/' : (ctx) => auth.isAuth?
              ProductOverviewGrid()
              :FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authResultSnapshot) =>
                authResultSnapshot.connectionState ==
                    ConnectionState.waiting
                    ? Center(child: CircularProgressIndicator())
                    : AuthScreen(),
              ),
              'orderScreen': (ctx) => OrdersScreen(),
              'productDetail': (ctx)=>ProductDetailScreen(),
              'CartScreen': (ctx) => CartScreen(),
              'UserProductScreen': (ctx) => UserProductScreen(),
              'EditProductScreen': (ctx) => EditProductScreen(),
            }
        ),
      ),
    );
  }
}

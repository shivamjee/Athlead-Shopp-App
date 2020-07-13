import 'package:flutter/material.dart';
import '../provider/cartItem.dart';
import '../provider/product_provider.dart';
import '../screens/drawerScreen.dart';
import '../widgets/productGridView.dart';
import 'package:provider/provider.dart';

class ProductOverviewGrid extends StatefulWidget
{
  @override
  _ProductOverviewGridState createState() => _ProductOverviewGridState();
}

class _ProductOverviewGridState extends State<ProductOverviewGrid> {
  int pageIndex=0;
  var init = true;
  var isLoading = false;

  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {

    if(init)
    {
      setState(() {
        isLoading = true;
      });
      Provider.of<Product_Provider>(context).fetchProduct().then(
          (_)
          {
            setState(() {
              isLoading = false;
            });
          }
      ).catchError((error){print(error);});
    }
    init = false;
    super.didChangeDependencies();
  }


  void rebuildPage()
  {
    setState(() {
      return;
    });
  }
  void selectPage(int index)
  {
    setState(() {
      pageIndex = index;
    });
  }
  Widget build(BuildContext context) {
    final cartData = Provider.of<Cart>(context,listen: true);
    //final List cartList = cartData.item;
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
      ),

      drawer: DrawerScreen(),
      body: isLoading?
          Center(
            child: CircularProgressIndicator(),
          )
          :RefreshIndicator(
        onRefresh: ()=>Provider.of<Product_Provider>(context,listen: false).fetchProduct(),
        child: ProductGridView(pageIndex,rebuildPage)
      ),

      floatingActionButton: FloatingActionButton(
        child:Stack(
          children: [
            Positioned(
                top: 18,
                left: 15,
                child: Icon(Icons.shopping_cart,color: Colors.white,)),
            Positioned(
                  top: 8,
                  left: 35,
                  child:Text(
                    (cartData.item.length.toString()),
                    style: TextStyle(fontSize: 14,color: Colors.white,fontWeight: FontWeight.bold),
                  ),
                ),
            ]
          ),
        elevation: 10,
        onPressed: (){Navigator.of(context).pushNamed(
            'CartScreen'
          );
        },
      ),

      bottomNavigationBar: BottomNavigationBar(
        onTap: selectPage,
        currentIndex: pageIndex,
        backgroundColor: Theme.of(context).primaryColor,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.work),
            title: Text('All'),
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: Icon(Icons.star),
            title: Text('Fav'),
          ),
        ],
      ),
    );
  }
}
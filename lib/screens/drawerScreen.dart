import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/Auth_Provider.dart';

class DrawerScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child:
      (Provider.of<AuthProvider>(context).userId == 'sfNq4YeiqWaWSscb8nvVmb2jIXt2'
          ||Provider.of<AuthProvider>(context).userId =='jU0CMvAJmWdMnkDyz5UmmpLTJcf2')?
      Column(
        children: <Widget>[
          AppBar(
            title: Text("Welcome"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop,size:26),
            title: Text("Shop"),
            onTap: ()=> Navigator.of(context).pushReplacementNamed('/'),

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment,size:26),
            title: Text("Orders"),
            onTap: ()=> Navigator.of(context).pushNamed('orderScreen'),

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit, size: 26),
            title: Text("Edit Products"),
            onTap: () =>
                Navigator.of(context).pushNamed('UserProductScreen'),
          ),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, size: 26),
            title: Text("Logout"),
            onTap: (){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context,listen: false).logOut();
              },
          ),
        ],
      )
      :Column(
        children: <Widget>[
          AppBar(
            title: Text("Welcome"),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop,size:26),
            title: Text("Shop"),
            onTap: ()=> Navigator.of(context).pushReplacementNamed('/'),

          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment,size:26),
            title: Text("Orders"),
            onTap: ()=> Navigator.of(context).pushNamed('orderScreen'),
          ),
          Spacer(),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app, size: 26),
            title: Text("Logout"),
            onTap:(){
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<AuthProvider>(context,listen: false).logOut();
            },
          ),
        ],
      ),
    );
  }
}
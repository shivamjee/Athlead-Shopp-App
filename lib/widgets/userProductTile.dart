import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class UserProductTile extends StatelessWidget
{
  final String id;
  final String title;
  final String imgUrl;

  UserProductTile(this.id,this.title,this.imgUrl);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
            children: <Widget>[
              IconButton(
                color: Theme.of(context).primaryColor,
                icon: Icon(Icons.edit),
                onPressed: (){
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                color: Colors.red,
                onPressed: (){
                  showDialog(
                    context: context,
                    builder: (ctx)=>AlertDialog(
                      title: Text("Are you sure?"),
                      content: Text("This product will be permanently deleted"),
                      actions: <Widget>[
                        FlatButton(
                          child: Text("NO"),
                          onPressed: ()=>Navigator.of(context).pop(),
                        ),
                        FlatButton(
                          child: Text("YES"),
                          onPressed: (){
                            Provider.of<Product_Provider>(context,listen: false).deleteProduct(id).then((response)
                            {
                              Navigator.of(context).pop();
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text(response,
                                  textAlign: TextAlign.center,
                                  style:TextStyle(color: Colors.red),
                                ),
                                duration: Duration(seconds: 2),
                                backgroundColor: Colors.black,
                                ),
                              );
                            }
                            );

                          },
                        ),
                      ],
                    ),
                  );
                },
              )
            ],
        ),
      ),
    );
  }
}
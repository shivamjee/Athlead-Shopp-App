import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';
import '../provider/product.dart';
class EditProductScreen extends StatefulWidget
{
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  @override
  final priceFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final imageUrlFocusNode = FocusNode();
  final imageUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var isLoading = false;
  var editedProduct = Product(
    id: null,
    title: "",
    price: 0.00,
    description: '',
    imageUrl: '',
  );
  void initState()
  {
    imageUrlFocusNode.addListener(updateImageUrl);
    super.initState();
  }
  void dispose()
  {
    imageUrlFocusNode.removeListener(updateImageUrl);
    priceFocusNode.dispose();
    descriptionFocusNode.dispose();
    imageUrlController.dispose();
    imageUrlFocusNode.dispose();
    super.dispose();
  }
  void updateImageUrl()
  {
    if (!imageUrlFocusNode.hasFocus) {
      if ((!imageUrlController.text.startsWith('http') &&
          !imageUrlController.text.startsWith('https')) ||
          (!imageUrlController.text.endsWith('.png') &&
              !imageUrlController.text.endsWith('.jpg') &&
              !imageUrlController.text.endsWith('.jpeg'))) {
        return;
      }
      setState(() {});
    }
  }

  Future<void> saveForm() async
  {
    isLoading = true;
    final isValid = formKey.currentState.validate();
    if (!isValid)
      return;
    formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try
    {
      await Provider.of<Product_Provider>(context,listen: false).addProduct(editedProduct);
    }
    catch(error)
    {
      await showDialog<Null>(
      context: context,
      builder: (ctx) => AlertDialog(
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
    finally
    {
      setState(() =>isLoading = false );
      Navigator.of(context).pop();
    }

  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add prodcut"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: saveForm,
            )
          ],
        ),
      body: isLoading
        ? Center(
          child: CircularProgressIndicator(),
        )
        :Form(
          key: formKey, // to be used when submitting
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_)
                {
                  FocusScope.of(context).requestFocus(priceFocusNode);
                },
                onSaved: (value)
                {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: value,
                    price: editedProduct.price,
                    description:editedProduct.description,
                    imageUrl: editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value.isEmpty)
                    return ' Please enter a Title';
                  else
                    return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                focusNode: priceFocusNode,
                onFieldSubmitted: (_)=>
                    FocusScope.of(context).requestFocus(descriptionFocusNode),
                onSaved: (value)
                {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: editedProduct.title,
                    price: double.parse(value),
                    description:editedProduct.description,
                    imageUrl: editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Please enter a Number';
                  if(double.tryParse(value)== null)
                    return 'Engter a valid number';
                  if(double.parse(value) <=0)
                    return ' Enter the price greater than 0';
                  else
                    return null;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                focusNode: descriptionFocusNode,
                onSaved: (value)
                {
                  editedProduct = Product(
                    id: editedProduct.id,
                    title: editedProduct.title,
                    price: editedProduct.price,
                    description: value,
                    imageUrl: editedProduct.imageUrl,
                  );
                },
                validator: (value){
                  if(value.isEmpty)
                    return 'Please enter a Description';
                  if(value.length<10)
                    return 'Please Provide more information';
                  else
                    return null;
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                        color: Colors.grey,
                      ),
                    ),
                    child: imageUrlController.text.isEmpty ?
                    Text('Enter URL'):FittedBox(
                      child: Image.network(
                        imageUrlController.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image URL'),
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.url,
                      controller: imageUrlController,
                      focusNode: imageUrlFocusNode,
                      onSaved: (value)
                      {
                        editedProduct = Product(
                          id: editedProduct.id,
                          title: editedProduct.title,
                          price: editedProduct.price,
                          description:editedProduct.description,
                          imageUrl: value,
                        );
                      },
                      onFieldSubmitted: (_)=>saveForm(),
                      validator: (value){
                        if(value.isEmpty)
                          return 'Please enter an Image URL';
                        else if(!value.startsWith('http')&& !value.startsWith('https'))
                          return 'Please provide a valid URL';
                        else if(!value.endsWith('.png')&& !value.endsWith('.jpg')&& !value.endsWith('.jpeg'))
                          return 'Please provide a valid URL';
                        else
                          return null;
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}




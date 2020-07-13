import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';
import '../models/httpException.dart' ;
import '../provider/Auth_Provider.dart';

class AuthScreen extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    final dimensions = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.black,Colors.blue[900]],
                  stops: [0.2,0.9],
                )
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: dimensions.height,
                width: dimensions.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                            margin: EdgeInsets.all(10.0),
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.red,
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 8,
                                  color: Colors.black26,
                                  //offset: Offset(0, 2),
                                )
                              ],
                            ),
                            child: Center(
                              child: Text(
                                  "ATHLEAD",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'audiowide',
                                ),
                              ),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Flexible(
                        flex: dimensions.width > 600 ? 2 : 1,
                        child: AuthForm()),
                  ],
                ),
              ),
            ),
          ],
        ),
    );
  }
}


enum AuthMode {signUp,login}
class AuthForm extends StatefulWidget
{
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> with SingleTickerProviderStateMixin{
  @override

  final passNode = FocusNode();
  final confirmPassNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  AuthMode authMode = AuthMode.login;
  Map<String, String> authData = {
    'email': '',
    'password': '',
  };
  var _isLoading = false;

  AnimationController controller;
  Animation<Offset> slideAnimation;
  Animation<double> opacityAnimation;

  void initState()
  {
    super.initState();
    controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
    );
    slideAnimation = Tween<Offset>(
      begin: Offset(0, -1.5),
      end: Offset(0, 0),
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.linear,
      ),
    );
    //heightAnimation.addListener(()=> setState((){}));

    opacityAnimation = Tween(
      begin: 0.0,
      end: 1.0,
      ).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.linear,
      ),
    );


  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }
  Future<void> alertWid (String errorMessage)  async
  {
    await showDialog<Null>(
      context: context,
      builder: (ctx) =>
          AlertDialog(
            title: Text('Oops!'),
            content: Text(errorMessage),
            actions: <Widget>[
              FlatButton(child: Text('Okay'), onPressed: () {
                Navigator.of(ctx).pop();
              },)
            ],
          ),
    );
  }
  Future<void> formSaved() async
  {

    final isValid = formKey.currentState.validate();
    if(!isValid)
      return;

    formKey.currentState.save();
    setState(() {

      _isLoading = true;
    });
    try
    {
      if (authMode == AuthMode.login) 
      {
        await Provider.of<AuthProvider>(context, listen: false).authenticate(
          authData['email'],
          authData['password'],
          'login',
        );
      }
      else
      {
        await Provider.of<AuthProvider>(context, listen: false).authenticate(
          authData['email'],
          authData['password'],
          'signup',
        );
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Sign in Successful'),
          duration: Duration(seconds: 2),
        ));
        formKey.currentState.reset();
      }
    }
    on httpException catch(error)
    {
      var errorMessage = 'Authentication failed';
      if(error.toString().contains('EMAIL_EXISTS'))
        errorMessage = 'Email Already Exists';
      else if(error.toString().contains('INVALID_EMAIL'))
        errorMessage = 'Enter a valid Email';
      else if(error.toString().contains('WEAK_PASSWORD'))
        errorMessage = 'This password is too weak';
      else if(error.toString().contains('EMAIL_NOT_FOUND'))
        errorMessage = 'Email not found';
      else if(error.toString().contains('INVALID_PASSWORD'))
        errorMessage = 'Invalid password';
      alertWid(errorMessage);

    }
    catch(error)
    {
      const errorMessage = 'Oops! Something went wrong. Try again later.';
      alertWid(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }
  void switchAuthMode()
  {
    if(authMode == AuthMode.login) {
      setState(() {
        authMode = AuthMode.signUp;
      });
      controller.forward();
    }
    else {
      setState(() {
        authMode = AuthMode.login;
      });
      controller.reverse();
    }

  }

  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.linear,
        height: authMode == AuthMode.signUp? 320 : 260,
        // height: _heightAnimation.value.height,
        constraints: BoxConstraints(minHeight: authMode == AuthMode.signUp ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(12.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_)=> FocusScope.of(context).requestFocus(passNode),
                  onSaved: (value){
                    authData['email'] = value;
                  },
                  validator: (value)
                  {
                    if(value.isEmpty)
                      return 'Cant be empty';
                    if(!value.endsWith('.com'))
                      return 'Enter valid email Id';
                    else
                      return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  focusNode: passNode,
                  keyboardType: TextInputType.visiblePassword,
                  textInputAction: authMode == AuthMode.login? TextInputAction.done:TextInputAction.next,
                  controller: passwordController,
                  onFieldSubmitted: (_)=>authMode == AuthMode.login? formSaved():FocusScope.of(context).requestFocus(confirmPassNode),
                  onSaved: (value){
                    authData['password'] = value;
                  },
                  validator: (value)
                  {
                    if(value.isEmpty)
                      return 'Cant be empty';
                    if(value.length<5)
                      return 'Password is too short';
                    else
                      return null;
                  },
                ),
                if(authMode == AuthMode.signUp)
                  AnimatedContainer(
                  constraints: BoxConstraints(
                    minHeight: authMode == AuthMode.signUp ? 60 : 0,
                    maxHeight: authMode == AuthMode.signUp ? 120 : 0,
                  ),
                  duration: Duration(milliseconds: 300),
                  curve: Curves.linear,
                  child: FadeTransition(
                    opacity: opacityAnimation,
                    child: SlideTransition(
                      position: slideAnimation,
                      child: TextFormField(
                        enabled: authMode == AuthMode.signUp,
                        focusNode: confirmPassNode,
                        decoration: InputDecoration(labelText: 'Confirm Password'),
                        obscureText: true,
                        keyboardType: TextInputType.visiblePassword,
                        textInputAction: TextInputAction.done,
                        onFieldSubmitted: (_)=> formSaved(),
                        //onSaved: (value){},
                        validator: (value)
                        {
                          if(value.isEmpty)
                            return 'Cant be empty';
                          if(value != passwordController.text)
                            return 'Password doesnt match';
                          else
                            return null;
                        },
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
               _isLoading?
               Center(
                 child: CircularProgressIndicator(),
               ):RaisedButton(
                 textColor: Colors.white,
                color: Colors.blue[900],
                child: Text((authMode == AuthMode.login) ?'LOGIN': ' SIGN-UP',),
                onPressed: formSaved,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                  ),
                ),
                FlatButton(
                    child: Text(
                      (authMode == AuthMode.login) ?"Or Sign up Instead":"Or Login instead",
                    style: TextStyle(color: Colors.blue[900]),
                    ),
                  onPressed: switchAuthMode,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
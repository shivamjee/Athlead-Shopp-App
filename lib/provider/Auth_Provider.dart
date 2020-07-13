import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/httpException.dart' ;
class AuthProvider with ChangeNotifier
{
  String _token;
  DateTime _expiryDate;
  String _userId;

  bool get isAuth
  {
    return token != null;
  }


  String get token{
    if(_expiryDate!= null && _expiryDate.isAfter(DateTime.now()) && _token != null)
      return _token;
    else
      return null;
  }


  String get userId
  {
    return _userId;
  }


  Future<void> authenticate(String email,String password,String lsup) async
  {
    var url;
    if(lsup == 'signup')
    {  url = 'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyCxV1VQAaqGm3Bg2xHBsDUiP4Jbra5x9Z8';}
    else
    {  url = 'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyCxV1VQAaqGm3Bg2xHBsDUiP4Jbra5x9Z8';}
    try
    {
      final response = await http.post(
          url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }
        )
      );
      final responseBody = json.decode(response.body);
      if(responseBody['error'] != null)
        throw httpException(responseBody['error']['message']);
      if(lsup == 'login')
      {
        _token = responseBody['idToken'];
        _userId = responseBody['localId'];
        _expiryDate = DateTime.now().add(
            Duration(seconds: int.parse(responseBody['expiresIn'])));
        notifyListeners();


        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode(
          {
            'token': _token,
            'userId': _userId,
            'expiryDate': _expiryDate.toIso8601String(),
          },);
        prefs.setString('userData', userData);
      }
    }
    catch(error)
    {
      throw error;
    }
  }


  Future<bool> tryAutoLogin() async
  {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final extractedUserData = json.decode(prefs.getString('userData')) as Map<String, Object>;
    final expiryDate = DateTime.parse(extractedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }
    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logOut() async
  {
    final prefs =await SharedPreferences.getInstance();
    _token = null;
    _userId = null;
    _expiryDate = null;
    notifyListeners();
    prefs.clear();

  }
}
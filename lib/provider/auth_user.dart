import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../models/httperror_delete.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class AuthUser with ChangeNotifier {
  bool _resEmail= false;
  String _token;
  DateTime _expireTime;
  String _userId;
  String _email;
  String fName;
  String lName;
  Future<void> auth(String email, String password, String method) async {
    try {
      final url =
          'https://identitytoolkit.googleapis.com/v1/accounts:$method?key=AIzaSyBO1_rzEkitGiIu8YmLNQWOW2vNVggRNdQ';
      var result = await http.post(url,
          body: json.encode({
            'email': email,
            'password': password,
            'returnSecureToken': true,
          }));
      final responce = json.decode(result.body);
      print(json.decode(result.body)['expiresIn']);

      if (responce['error'] != null) {
        throw HttpError(responce['error']['message']);
      }
      _token = responce['idToken'];
      _userId = responce['localId'];
      _email = responce['email'];
      _expireTime = DateTime.now().add(Duration(
        seconds: int.parse(responce['expiresIn']),
      ));
      if (method == 'signUp') {
        String url1 =
            'https://uptrip-cef8f.firebaseio.com/users/$email.json?';
        await http.post(url1,
            body: json.encode({
              'firstName': fName,
              'lastName': lName,
            }));
        print('ok');
      }
      final pref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'idToken': _token,
        'localId': _userId,
        'expireTime': _expireTime.toIso8601String(),
        'email':_email,
      });
      pref.setString('userData', userData);
      if(email.contains('@uptrip')){
          _resEmail = true;
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
  bool get resEmail{
    if(_resEmail)
        return true;
    else 
      return false;
  }
  Future<bool> autoLogin() async {
    final pref = await SharedPreferences.getInstance();
    if (pref == null) return false;
    final userData =
        json.decode(pref.getString('userData')) as Map<String, dynamic>;
    DateTime expireTime = DateTime.parse(userData['expireTime']);
    if (expireTime.isBefore(DateTime.now())) return false;

    _token = userData['idToken'];
    _userId = userData['localId'];
    _expireTime = expireTime;
    _email = userData['email'];
    _resEmail = true;

    notifyListeners();
    return true;
  }

  bool get isAuth {
    return token != null;
  }

  String get userEmail {
    if (_token != null &&
        _expireTime.isAfter(DateTime.now()) &&
        _expireTime != null) return _email;
    return null;
  }

  String get token {
    if (_token != null &&
        _expireTime.isAfter(DateTime.now()) &&
        _expireTime != null) return _token;
    return null;
  }

  String get userId {
    if (_userId != null &&
        _expireTime.isAfter(DateTime.now()) &&
        _expireTime != null) return _userId;
    return null;
  }

  Future<void> signUpUser(
      String email, String password, String firstName, String lastName) async {
    fName = firstName;
    lName = lastName;
    return auth(email, password, 'signUp');
  }

  Future<void> signInUser(String email, String password) async {
    return auth(email, password, 'signInWithPassword');
  }

  Future<void> logout() async{
    _token = null;
    _expireTime = null;
    _userId = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userData');
    prefs.clear();
  }
}

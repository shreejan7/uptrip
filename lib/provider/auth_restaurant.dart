import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/httperror_delete.dart';
import 'dart:convert';

class AuthRestaurant with ChangeNotifier {
  String rName;
  String oName;
  String pNumber;
  String resRegId;
  String mail;
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

      final token = responce['idToken'];

      if (responce['error'] != null) {
        throw HttpError(responce['error']['message']);
      }
      final urlEmail = email.replaceAll(RegExp(r'[^\w\s]+'), '');
      print(urlEmail);
      String url1 = 'https://uptrip-cef8f.firebaseio.com/restaurantUsers.json?';
      await http
          .post(url1,
              body: json.encode({
                'restaurantName': rName,
                'ownerName': oName,
                'restaurnantRegisterId': resRegId,
                'phoneNumber': pNumber,
                'email': mail,
                'forRestaurant': urlEmail,
                'description': '',
                'locationLatitude': '',
                'locationLongitude': '',
                'imgUrl': '',
                'location': '',
                'filterLocation': '',
                'time': '',
              }))
          .then((va) {
        print(json.decode(va.body));
      });
      print('ok');
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> signUpRestaurant(
    String restaurantName,
    String ownerName,
    String restaurnantRegisterId,
    String phoneNumber,
    String email,
    String resEmail,
    String password,
  ) async {
    rName = restaurantName;
    oName = ownerName;
    resRegId = restaurnantRegisterId;
    pNumber = phoneNumber;
    mail = email;
    return auth(resEmail, password, 'signUp');
  }
}

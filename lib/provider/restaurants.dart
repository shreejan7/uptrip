import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import './restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Restaurants with ChangeNotifier {
  final String authToken;
  final String userId;
  final String email;
  Restaurants(this.authToken, this.userId, this.email);
  

  Future<void> addRestaurant(
      Restaurant restaurantData, String userEmail,String idRes) async {
    final address = await Location().getLocation();
    Coordinates coordinate =
        new Coordinates(address.latitude, address.longitude);
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinate);
    String addressPostal = addresses.first.postalCode.toString();
    String addressCity = addresses.first.locality;
    String adressroad = addresses.first.featureName;
    String filter =
        addressCity + addressPostal + adressroad.replaceAll(' ', '');
    print(filter);
    print(restaurantData.name);
    String url ;
    print(userEmail.toString());
     url = 'https://uptrip-cef8f.firebaseio.com/restaurantUsers/$idRes.json?';
    http.patch(url,body: json.encode(
                  {
                    'restaurantName': restaurantData.name,
                    'description': restaurantData.description,
                    'locationLatitude': restaurantData.locationLatitude,
                    'locationLongitude': restaurantData.locationLongitude,
                    'imgUrl': restaurantData.imgUrl,
                    'forRestaurant':userEmail,
                    'location': addresses.first.addressLine,
                    'time':DateTime.now().toString(),
                    'filterLocation':filter,
                  },)).then((v){
                    print(json.decode(v.body));
                  });
    // String url =
    //     'https://uptrip-cef8f.firebaseio.com/restaurant/$addressCity/$filter.json?';
    // http
    //     .post(url,
    //         body: json.encode(
    //           {
    //             'name': restaurantData.name,
    //             'description': restaurantData.description,
    //             'locationLatitude': restaurantData.locationLatitude,
    //             'locationLongitude': restaurantData.locationLongitude,
    //             'imgUrl': restaurantData.imgUrl,
    //             'isFavourite': restaurantData.isFavourite,
    //             'location': addresses.first.addressLine,
    //           },
    //         ))
    //     .then((response) {
    //   firstId = json.decode(response.body)['name'].toString();
    //   print('done 1');
    //   url = 'https://uptrip-cef8f.firebaseio.com/newRestaurant.json?';
    //   http
    //       .post(url,
    //           body: json.encode(
    //             {
    //               'name': restaurantData.name,
    //               'description': restaurantData.description,
    //               'locationLatitude': restaurantData.locationLatitude,
    //               'locationLongitude': restaurantData.locationLongitude,
    //               'imgUrl': restaurantData.imgUrl,
    //               'isFavourite': restaurantData.isFavourite,
    //               'location': addresses.first.addressLine,
    //             },
    //           ))
    //       .then((response) async {
    //     secondId = json.decode(response.body)['name'].toString();
    //     url =
    //         'https://uptrip-cef8f.firebaseio.com/restaurantUsers/$userEmail.json?';
    //     String idFinal;
    //     final id = await http.get(url);
    //     Map<String, dynamic> idValue = json.decode(id.body);
    //     idValue.forEach((id, val) {
    //       idFinal = id;
    //     });
    //     print(userEmail);
    //     url =
    //         'https://uptrip-cef8f.firebaseio.com/restaurantUsers/$userEmail/$idFinal.json?';
    //     http
    //         .patch(url,
    //             body: json.encode(
    //               {
    //                 'restaurantName': restaurantData.name,
    //                 'description': restaurantData.description,
    //                 'locationLatitude': restaurantData.locationLatitude,
    //                 'locationLongitude': restaurantData.locationLongitude,
    //                 'imgUrl': restaurantData.imgUrl,
    //                 'location': addresses.first.addressLine,
    //               },
    //             ))
    //         .then((response) {
    //     url =
    //         'https://uptrip-cef8f.firebaseio.com/forFood/$userEmail.json?';
    //         http.post(url,body:json.encode({
    //           'userEmail':userEmail,
    //           'firstId':firstId,
    //           'secondId':secondId,
    //         }));
    //       print('ok done');
    //       print(firstId);
    //       print(secondId);
    //     });

    //     notifyListeners();
    //   });
    // }).catchError((error) {
    //   throw error;
    // });
  }

  
}

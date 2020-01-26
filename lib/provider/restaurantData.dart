import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import './restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RestaurantData with ChangeNotifier{
  List<Restaurant> _item = [];
  // List<Restaurant> _itemSearch = [];
  List<Restaurant> get item {
    return [..._item];
  }

  List<Restaurant> get fav {
    return _item.where((productItem) => productItem.isFavourite).toList();
  }

Future<int> fetchNewRestaurantData(String userId) async {
    _item = [];
    String url = 'https://uptrip-cef8f.firebaseio.com/restaurantUsers.json';
    var res;
    try {
      final restaurantData = await http.get(url);
      
      if (restaurantData.statusCode >= 400) {
        return -5;
      }
      // print(json.decode(restaurantData.body));
      final eachData =
          await json.decode(restaurantData.body) as Map<String, dynamic>;
      if (eachData.isEmpty) return 0;
      print("This is a each"+eachData.toString());
      url = "https://uptrip-cef8f.firebaseio.com/userFavorites/$userId.json?";
      res = await http.get(url);
      final resData = json.decode(res.body);
      eachData.forEach((id, eachData) async {
        _item.add(
          new Restaurant(
            id: id,
            name: eachData['restaurantName'],
            description: eachData['description'],
            locationLatitude: eachData['locationLatitude'],
            locationLongitude: eachData['locationLongitude'],
            imgUrl: eachData['imgUrl'],
            location: eachData['location'],
            resName:eachData['forRestaurant'],
            isFavourite: resData == null ? false : resData[id] ?? false,
          ),
        );
        notifyListeners();
      });
    } catch (error) {
      throw error.toString();
    }
    return item.length;
  }

  var addressPoint;
  Future<int> fetchAndSetRestaurantData(String userId) async {
    await Location().getLocation().then((address) async {
      Coordinates coordinate =
          new Coordinates(address.latitude, address.longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinate);
      _item = [];
      String addressPostal = addresses.first.postalCode.toString();
      String addressCity = addresses.first.locality;
      String adressroad = addresses.first.featureName;
      print(adressroad);
      String filter =
          addressCity + addressPostal + adressroad.replaceAll(' ', '');
          print("This is filter"+ filter);
      String url =
          'https://uptrip-cef8f.firebaseio.com/restaurantUsers.json?orderBy="filterLocation"&equalTo="$filter"';
      try {
        final restaurantData = await http.get(url);
        final eachData =
            json.decode(restaurantData.body) as Map<String, dynamic>;
        if (eachData == null) throw 'null';
        if (eachData.isEmpty) return 0;
        url =
            'https://uptrip-cef8f.firebaseio.com/userFavorites/$userId.json?';
        final res = await http.get(url);
        final favStatus = json.decode(res.body);
        eachData.forEach((id, eachData) {
          _item.add(
            new Restaurant(
              id: id,
            name: eachData['restaurantName'],
            description: eachData['description'],
            locationLatitude: eachData['locationLatitude'],
            locationLongitude: eachData['locationLongitude'],
            imgUrl: eachData['imgUrl'],
            location: eachData['location'],
            resName:eachData['forRestaurant'],
            isFavourite:favStatus == null ? false : favStatus[id] ?? false,
            ),
          );
          notifyListeners();
        });
      } catch (error) {
        throw error.toString();
      }
    });
    return item.length;
  }
}
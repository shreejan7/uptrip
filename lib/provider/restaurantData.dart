import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart';
import './restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class RestaurantData with ChangeNotifier {
  List<Restaurant> _item = [];
  // List<Restaurant> _itemSearch = [];
  List<Restaurant> get item {
    return _item;
  }

  List<Restaurant> get fav {
    return _item.where((productItem) => productItem.isFavourite).toList();
  }

  Future<int> fetchNewRestaurantData(String userId) async {
    _item = [];
    List<Restaurant> data = [];
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
      url = "https://uptrip-cef8f.firebaseio.com/userFavorites/$userId.json?";
      res = await http.get(url);
      final resData = json.decode(res.body);
      eachData.forEach((id, eachData) async {
        data.add(
          new Restaurant(
            id: id,
            name: eachData['restaurantName'],
            description: eachData['description'],
            locationLatitude: eachData['locationLatitude'],
            locationLongitude: eachData['locationLongitude'],
            imgUrl: eachData['imgUrl'],
            location: eachData['location'],
            resName: eachData['forRestaurant'],
            isFavourite: resData == null ? false : resData[id] ?? false,
          ),
        );
        Iterable inReverse = data.reversed;
        _item = inReverse.toList();
        notifyListeners();
      });
    } catch (error) {
      throw error.toString();
    }
    return 1;
  }

  var addressPoint;
  Future<int> fetchAndSetRestaurantData(String userId) async {
    _item = [];
    // List<Restaurant> data = [];
    final address = await Location().getLocation();
    final List<String> locations =
        await findLocation(address.latitude, address.longitude);
        print(locations.toString());
    for (int i = 0; i < locations.length; i++) {
      String url =
          'https://uptrip-cef8f.firebaseio.com/restaurantUsers.json?orderBy="filterLocation"&equalTo="${locations[i]}"';
      try {
        final restaurantData = await http.get(url);
        final eachData =
            json.decode(restaurantData.body) as Map<String, dynamic>;
        // if (eachData == null) throw 'null';
        // if (eachData.isEmpty) return 0;
        url = 'https://uptrip-cef8f.firebaseio.com/userFavorites/$userId.json?';
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
              resName: eachData['forRestaurant'],
              isFavourite: favStatus == null ? false : favStatus[id] ?? false,
            ),
          );
          notifyListeners();
        });
      } catch (error) {
        throw error.toString();
      }
    }
    // Coordinates coordinate =
    //     new Coordinates(address.latitude, address.longitude);
    // final addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinate);
    // String addressPostal = addresses.first.postalCode.toString();
    // String addressCity = addresses.first.locality;
    // String adressroad = addresses.first.featureName;
    // print(adressroad);
    // String filter =
    //     addressCity + addressPostal + adressroad.replaceAll(' ', '');
    //     print("This is filter"+ filter);
    if (item.length == 0) return 0;
    return 1;
  }

  Future<List<String>> findLocation(double latitude, double longitude) async {
    List<String> location = [];
    int rearth = 6378000;
    int dy = 0;
    int dx = 0;
    int i;
    int y = 1;
    int a = 1;
    //The number of kilometers per degree of longitude is approximately
//(2*pi/360) * r_earth * cos(theta)
//where theta is the latitude in degrees and r_earth is approximately 6378 km.
//The number of kilometers per degree of latitude is approximately the same at all locations, approx
//(2*pi/360) * r_earth = 111 km / degree
    do {
      i = 0;
      latitude = latitude + (dy / rearth) * (180 / pi);
      longitude =
          longitude + (dx / rearth) * (180 / pi) / cos(latitude * pi / 180);
      Coordinates coordinate = new Coordinates(latitude, longitude);
      final addresses =
          await Geocoder.local.findAddressesFromCoordinates(coordinate);
       String addressPostal = addresses.first.postalCode;
      String addressCity = addresses.first.locality;
      String adressroad = addresses.first.featureName;
      if(addressCity!=null && addressPostal!=null && adressroad !=null){
        String filter =
          addressCity + addressPostal + adressroad.replaceAll(' ', '');
           location.forEach((val) {
        if (filter == val) {
          i++;
        }
      });
      if (i == 0) {
        location.add(filter);
      }
      if (a.isOdd)
        dx = (100 * y);
      else
        dy = (100 * y);
      if (a % 4 == 0) y++;
      y = -y;
      a++;
      }
    } while (location.length <= 5);
    print(location.toString());
    return location;
  }
  Future<List<Restaurant>> search(String value,String userId) async{
    value = value.toLowerCase();
    print(value);
    List<Restaurant> restu=[];
    String url = 'https://uptrip-cef8f.firebaseio.com/restaurantUsers.json?orderBy="searchName"&equalTo="$value"';
    final val = await http.get(url);
    final eachData =
          await json.decode(val.body) as Map<String, dynamic>;
      if (eachData.isEmpty)
          throw "no data";
      print("This is a each" + eachData.toString());
      url = "https://uptrip-cef8f.firebaseio.com/userFavorites/$userId.json?";
      
      var res = await http.get(url);
      var resData;
       resData = await json.decode(res.body);

      eachData.forEach((id, eachData) async {
        restu.add(
          new Restaurant(
            id: id,
            name: eachData['restaurantName'],
            description: eachData['description'],
            locationLatitude: eachData['locationLatitude'],
            locationLongitude: eachData['locationLongitude'],
            imgUrl: eachData['imgUrl'],
            location: eachData['location'],
            resName: eachData['forRestaurant'],
            isFavourite: resData == null ? false : resData[id] ?? false,
          ),
        );
        notifyListeners();
      });
      return restu;
  }
}

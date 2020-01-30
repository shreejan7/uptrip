import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Restaurant with ChangeNotifier  {
  final String id;
  final String name;
  final String description;
  final double locationLatitude;
  final double locationLongitude;
  final String imgUrl;
  final String location;
  final String resName;
  bool isFavourite;

 Restaurant({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.locationLatitude,
    @required this.locationLongitude,
    @required this.imgUrl,
    @required this.location,
    @required this.resName,

    this.isFavourite= false,
  });

  void _setFavValue(bool newValue) {
    isFavourite = newValue;
    notifyListeners();
  }
  Future<void> isfavorite(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = !isFavourite;
    notifyListeners();
    final url =
        'https://uptrip-cef8f.firebaseio.com/userFavorites/$userId/$id.json?';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
  Future<void> isfav(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = true;
    notifyListeners();
    final url =
        'https://uptrip-cef8f.firebaseio.com/userFavorites/$userId/$id.json?';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
  Future<void> notIsFav(String token, String userId) async {
    final oldStatus = isFavourite;
    isFavourite = false;
    notifyListeners();
    final url =
        'https://uptrip-cef8f.firebaseio.com/userFavorites/$userId/$id.json?';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavourite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }
}


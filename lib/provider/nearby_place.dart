import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NearbyPlace with ChangeNotifier{
  String url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=-33.8670522,151.1957362&radius=1500&type=restaurant&keyword=cruise&key=AIzaSyAG2nZGysj3E6bXOGqn5RMCm9ViftriZH4';

  Future<void> fetchNearbyPlaces() async{
    final result = await http.get(url);
    final ans = json.decode(result.body);
    print(ans);
    notifyListeners();
  }
}
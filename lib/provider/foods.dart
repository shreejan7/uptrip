import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:uptrip/models/httperror_delete.dart';
import './food.dart';
import 'package:http/http.dart' as http;

class Foods with ChangeNotifier {
  final String _authToken;
  final String _email;
  List<Food> _item = [];
  Foods(
    this._authToken,
    this._email,
    this._item,
  );
  List<Food> get item {
    return _item;
  }

  Future<void> addFood(Food food) async {
    print("tis si email" + _email);
    final urlEmail = _email.replaceAll(RegExp(r'[^\w\s]+'), '');
    final String url = 'https://uptrip-cef8f.firebaseio.com/food.json?';

    try {
      final responce = await http.post(url,
          body: json.encode({
            'name': food.name,
            'description': food.description,
            'price': food.price,
            'imgUrl': food.imgUrl,
            'restaurantId': food.restaurantId,
            'isfavourite': food.isFavourite,
            'resName': urlEmail
          }));

      final foodData = new Food(
        id: json.decode(responce.body)['name'],
        name: food.name,
        description: food.description,
        price: food.price,
        imgUrl: food.imgUrl,
        restaurantId: food.restaurantId,
        isFavourite: food.isFavourite,
      );
      _item.add(foodData);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteFood(String id) async {
    print(id);
    final String url =
        'https://uptrip-cef8f.firebaseio.com/food/$id.json?';
    final foodIndex = _item.indexWhere((food) => food.id == id);
    var foodData = _item[foodIndex];
    _item.removeAt(foodIndex);
    // notifyListeners();
    final val = await http.delete(url);
    if (val.statusCode >= 400) {
      print('Statuscode is ' + val.statusCode.toString());
      _item.insert(foodIndex, foodData);
      notifyListeners();
      throw HttpError('There is an error in the deletion process');
    }
    // foodData = null;
  }

  Future<void> fetchAndSetFoodsData(String resName) async {
    _item = [];

    final String url =
        'https://uptrip-cef8f.firebaseio.com/food.json?orderBy="resName"&equalTo="$resName"';
    try {
      final foodData = await http.get(url);
      print('This is body = ' + json.decode(foodData.body).toString());
      final value = json.decode(foodData.body) as Map<String, dynamic>;
      if (value.isEmpty) return;
      value.forEach((id, value) {
        _item.add(
          new Food(
            id: id,
            name: value['name'],
            description: value['description'],
            imgUrl: value['imgUrl'],
            price: value['price'],
            restaurantId: value['resName'],
          ),
        );
      });
      notifyListeners();
    } catch (error) {

    }
  }

Future<int> fetchAndSetFoods() async {
  final urlEmail = _email.replaceAll(RegExp(r'[^\w\s]+'), '');
    _item = [];
    final String url =
        'https://uptrip-cef8f.firebaseio.com/food.json?orderBy="resName"&equalTo="$urlEmail"';
    try {
      final foodData = await http.get(url);
      print('This is body = ' + json.decode(foodData.body).toString());
      final value = json.decode(foodData.body) as Map<String, dynamic>;
      if (value.isEmpty) return 0;
      value.forEach((id, value) {
        _item.add(
          new Food(
            id: id,
            name: value['name'],
            description: value['description'],
            imgUrl: value['imgUrl'],
            price: value['price'],
            restaurantId: value['resName'],
          ),
        );
      });
      notifyListeners();
    } catch (error) {
      
    }
      return 1;

  }
  Food findById(String id) {
    print('THid is it' +
        _item.firstWhere((foodId) => foodId.id == id).toString());
    return _item.firstWhere((foodId) => foodId.id == id);
  }

  void upDateFood(String name, Food food) {
      print(name);

    // final foodToUpdate = _item.indexWhere((pro) => pro.name == name);
    // if (foodToUpdate > 0) {
      final String url =
          'https://uptrip-cef8f.firebaseio.com/food/$name.json?';

      http.patch(url,
          body: json.encode({
            'name': food.name,
            'description': food.description,
            'price': food.price,
            'imgUrl': food.imgUrl,
            'restaurantId': food.restaurantId,
            'isfavourite': food.isFavourite,
          }));
      notifyListeners();
    // }
  }
}

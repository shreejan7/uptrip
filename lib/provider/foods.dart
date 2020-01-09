import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:uptrip/models/httperror_delete.dart';
import './food.dart';
import 'package:http/http.dart' as http;

class Foods with ChangeNotifier {
  static const url = 'https://uptrip-cef8f.firebaseio.com/food.json';
  List<Food> _item = [
    // Food(
    //   id: '1',
    //   restaurantId: '2',
    //   name: 'chicken',
    //   price: 100,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '2',
    //   restaurantId: '2',
    //   name: 'buff momo',
    //   price: 100,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '3',
    //   restaurantId: '2',
    //   name: 'buff momo',
    //   price: 150,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '1',
    //   restaurantId: '3',
    //   name: 'buff momo',
    //   price: 170,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '2',
    //   restaurantId: '3',
    //   name: 'buff momo',
    //   price: 100,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '3',
    //   restaurantId: '3',
    //   name: 'buff momo',
    //   price: 100,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '1',
    //   restaurantId: '2',
    //   name: 'buff momo',
    //   price: 100,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '1',
    //   restaurantId: '2',
    //   name: 'buff momo',
    //   price: 100,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Food(
    //   id: '7',
    //   restaurantId: '3',
    //   name: 'sea momo',
    //   price: 100,
    //   description: 'We serve momo that is hygenic',
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
  ];
  List<Food> temp =[];
  List<Food> get item {
    return [..._item];
  }

  List<Food> restaurantFood(String restaurantId) {
    return [..._item]
        .where((food) => food.restaurantId == restaurantId)
        .toList();
  }

  Future<void> fetchAndSetFoodsData() async {
    _item=[];
    print('executed');
    try {
      final foodData = await http.get(url);
      
      print(json.decode(foodData.body));
      final value = json.decode(foodData.body) as Map<String, dynamic>;
      if(value.isEmpty)
        return;
      value.forEach((id, value) {
        _item.add(
          new Food(
            id: id,
            name: value['name'],
            description: value['description'],
            imgUrl: value['imgUrl'],
            price: value['price'],
            restaurantId: value['restaurantId'],
          ),
        );
        notifyListeners();
      }
      ); 
    } catch (error) {}
  }

  Future<void> addFood(Food food) async {
    try {
      final responce = await http.post(url,
          body: json.encode({
            'name': food.name,
            'description': food.description,
            'price': food.price,
            'imgUrl': food.imgUrl,
            'restaurantId': food.restaurantId,
            'isfavourite': food.isFavourite,
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

  Future<void> deleteFood(String id) async{
    final url = 'https://uptrip-cef8f.firebaseio.com/food/$id.json';
    final foodIndex = _item.indexWhere((food)=>food.id == id);
    var foodData= _item[foodIndex];
    _item.removeAt(foodIndex);
    notifyListeners();
    final val = await http.delete(url);

         if (val.statusCode >= 400) {
           print('Statuscode is '+val.statusCode.toString());
           _item.insert(foodIndex, foodData);
           notifyListeners();
              throw HttpError('There is an error in the deletion process');
         }
        foodData = null;
    
  }

  Food findById(String id) {
    return _item.firstWhere((foodId) => foodId.id == id);
  }

  void upDateFood(String id, Food food) {
    // final foodToUpdate = _item.indexWhere((pro) => pro.id == id);
    final url = 'https://uptrip-cef8f.firebaseio.com/food/$id.json';
    http.patch(url,body: json.encode({
            'name': food.name,
            'description': food.description,
            'price': food.price,
            'imgUrl': food.imgUrl,
            'restaurantId': food.restaurantId,
            'isfavourite': food.isFavourite,
    }));
    notifyListeners();
  }
}

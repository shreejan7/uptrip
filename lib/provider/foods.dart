import 'package:flutter/material.dart';
import './food.dart';

class Foods with ChangeNotifier {
  List<Food> _item = [
    Food(
      id: '1',
      restaurantId: '2',
      name: 'chicken',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '2',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '2',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '2',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '2',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '2',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '2',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '2',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Food(
      id: '1',
      restaurantId: '3',
      name: 'buff momo',
      price: 100,
      description: 'We serve momo that is hygenic',
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
  ];

  List<Food> get item {
    return [..._item];
  }
  
  List<Food> restaurantFood(String restaurantId){
    return [..._item].where((food)=>food.restaurantId==restaurantId).toList();
  }
  void addFood() {
    notifyListeners();
  }
}

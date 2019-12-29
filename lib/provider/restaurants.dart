import 'package:flutter/material.dart';
import './restaurant.dart';

class Restaurants with ChangeNotifier {
  List<Restaurant> _item = [
    Restaurant(
      id: '2',
      name: 'Lahana',
      description:
          'This is a newari restaurant. This is a newari restaurant. This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Restaurant(
      id: '3',
      name: 'Sasa',
      description: 'This is a newari restaurant',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Restaurant(
      id: '32',
      name: 'Sasa3',
      description: 'This is a newari restaurant',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Restaurant(
      id: '44',
      name: 'Sasa4',
      description: 'This is a newari restaurant',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Restaurant(
      id: '50',
      name: 'Sasa5',
      description: 'This is a newari restaurant',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Restaurant(
      id: '58',
      name: 'Sasa5',
      description: 'This is a newari restaurant',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Restaurant(
      id: '54',
      name: 'Sasa5',
      description: 'This is a newari restaurant',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
    Restaurant(
      id: '65',
      name: 'Sasa5',
      description: 'This is a newari restaurant',
      location: "Kalanki",
      imgUrl:
          'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    ),
  ];

  List<Restaurant> get item {
    return [..._item];
  }

  List<Restaurant> get fav {
    return _item.where((productItem) => productItem.isFavourite).toList();
  }
//  void showFav(){
//    _isFavourite=true;
//    notifyListeners();
//  }

//   void showAll(){
//     _isFavourite=false;
//     notifyListeners();
//   }

  Restaurant findById(String id) {
    return _item.firstWhere((pro) => pro.id == id);
  }
 
  void addRestaurant() {
    notifyListeners();
  }
}

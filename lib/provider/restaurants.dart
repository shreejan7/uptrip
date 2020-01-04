
import 'package:flutter/material.dart';
import './restaurant.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Restaurants with ChangeNotifier {
  static const url = 'https://uptrip-cef8f.firebaseio.com/restaurant.json';
  List<Restaurant> _item = [
    // Restaurant(
    //   id: '2',
    //   name: 'Lahana',
    //   description:
    //       'This is a newari restaurant. This is a newari restaurant. This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.This is a newari restaurant.',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Restaurant(
    //   id: '3',
    //   name: 'Sasa',
    //   description: 'This is a newari restaurant',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Restaurant(
    //   id: '32',
    //   name: 'Sasa3',
    //   description: 'This is a newari restaurant',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Restaurant(
    //   id: '44',
    //   name: 'Sasa4',
    //   description: 'This is a newari restaurant',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Restaurant(
    //   id: '50',
    //   name: 'Sasa5',
    //   description: 'This is a newari restaurant',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Restaurant(
    //   id: '58',
    //   name: 'Sasa5',
    //   description: 'This is a newari restaurant',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Restaurant(
    //   id: '54',
    //   name: 'Sasa5',
    //   description: 'This is a newari restaurant',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
    // Restaurant(
    //   id: '65',
    //   name: 'Sasa5',
    //   description: 'This is a newari restaurant',
    //   location: "Kalanki",
    //   imgUrl:
    //       'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    // ),
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

  void update(String id,Restaurant restaurantData){
    final url='https://uptrip-cef8f.firebaseio.com/restaurant/$id.json';
    http.patch(url,body:json.encode(
        {
          'id': restaurantData.id,
                'name': restaurantData.name,
                'description': restaurantData.description,
                'location': restaurantData.location,
                'imgUrl': restaurantData.imgUrl,
                'isFavourite': restaurantData.isFavourite,

        }
    ));
  }
  void addRestaurant(Restaurant restaurantData) {
    http
        .post(url,
            body: json.encode(
              {
                'id': restaurantData.id,
                'name': restaurantData.name,
                'description': restaurantData.description,
                'location': restaurantData.location,
                'imgUrl': restaurantData.imgUrl,
                'isFavourite': restaurantData.isFavourite,
              },
            ))
        .then((response) {
      _item.add(new Restaurant(
        id: json.decode(response.body)['name'],
        description: restaurantData.description,
        name: restaurantData.name,
        location: restaurantData.location,
        imgUrl: restaurantData.imgUrl,
        isFavourite: restaurantData.isFavourite,
      ));
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> fetchAndSetRestaurantData() async {
    _item=[];
    try {
      final restaurantData = await http.get(url);
      print(json.decode(restaurantData.body));
      final eachData = json.decode(restaurantData.body) as Map<String, dynamic>;

      eachData.forEach((id, eachData) {
        _item.add(
          new Restaurant(
            id: id,
            name: eachData['name'],
            description: eachData['description'],
            location: eachData['location'],
            imgUrl: eachData['imgUrl'],
          ),
        );
    notifyListeners();

      });
    } catch (error) {}
  }
}

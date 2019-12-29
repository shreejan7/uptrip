import 'package:flutter/foundation.dart';

class Food with ChangeNotifier{
  String id;
  String restaurantId;
  String name;
  double price;
  String description;
  String imgUrl;
  bool isFavourite;

  Food({
    @required this.id,
    @required this.restaurantId,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.imgUrl,
    this.isFavourite=false,
  });
  void isfav(){
      isFavourite = !isFavourite;
      notifyListeners();

  }
}
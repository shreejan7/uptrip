import 'package:flutter/foundation.dart';


class Restaurant with ChangeNotifier  {
  final String id;
  final String name;
  final String description;
  final String location;
  final String imgUrl;
  bool isFavourite;

 Restaurant({
    @required this.id,
    @required this.name,
    @required this.description,
    @required this.location,
    @required this.imgUrl,
    this.isFavourite= false,
  });

  void isfav(){
      isFavourite = !isFavourite;
      notifyListeners();

  }
}

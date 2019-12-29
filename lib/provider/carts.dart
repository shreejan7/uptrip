import 'package:flutter/foundation.dart';

class CartItem with ChangeNotifier {
  String id;
  String name;
  double price;
  int quantity;

  CartItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.quantity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _item = {};

  Map<String, CartItem> get item {
    return {..._item};
  }

  int get totalNumber {
    return _item.length;
  }
  double get totalPrice{
    var total = 0.0;
    _item.forEach((key,cartItem)=>
    total+=cartItem.price*cartItem.quantity);

    return  total;
  }
   void removeItem(String foodId){
     if(_item.containsKey(foodId)){
       _item.remove(foodId,);
     }
    notifyListeners();
   }
  void addItem(String foodId, String name, double price) {
    if (_item.containsKey(foodId)) {
      _item.update(
          foodId,
          (existingCart) => CartItem(
                id: existingCart.id,
                name: existingCart.name,
                price: existingCart.price,
                quantity: existingCart.quantity + 1,
              ));
    } else {
      _item.putIfAbsent(
          foodId,
          () => CartItem(
                id: DateTime.now().toString(),
                name: name,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }
  void removeQuantity(String foodId){
      if(_item.containsKey(foodId)){
          _item.update(
          foodId,
          (existingCart) => CartItem(
                id: existingCart.id,
                name: existingCart.name,
                price: existingCart.price,
                quantity: existingCart.quantity >0?existingCart.quantity-1:existingCart.quantity,
              ));
      }
      notifyListeners();
  }

  void addQuantity(String foodId){
     if (_item.containsKey(foodId)){
          _item.update(foodId,(existingCart)=>
          CartItem(
              id: existingCart.id,
              name: existingCart.name,
              price: existingCart.price,
              quantity: existingCart.quantity+1,
          ));
      }
      notifyListeners();
  }
  void remove(){
    _item={};
    notifyListeners();
  }
  void removeSingleItem(String foodId){
    if(!_item.containsKey(foodId))
      return;
    if(_item[foodId].quantity < 1){
      _item.update(foodId,(existingCart)=>
          CartItem(
              id: existingCart.id,
              name: existingCart.name,
              price: existingCart.price,
              quantity: existingCart.quantity-1,
          )
          );
    }
    else
      _item.remove(foodId);
      notifyListeners();
  }
}
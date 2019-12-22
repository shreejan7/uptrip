import 'package:flutter/foundation.dart';

class OrderItem with ChangeNotifier {
  String id;
  String name;
  double price;
  int quantity;

  OrderItem({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.quantity,
  });
}

class Order with ChangeNotifier {
  Map<String, OrderItem> _item = {};

  Map<String, OrderItem> get item {
    return {..._item};
  }

  int get totalNumber {
    return _item.length;
  }

  void addItem(String foodId, String name, double price) {
    if (_item.containsKey(foodId)) {
      _item.update(
          foodId,
          (existingOrder) => OrderItem(
                id: existingOrder.id,
                name: existingOrder.name,
                price: existingOrder.price,
                quantity: existingOrder.quantity + 1,
              ));
    } else {
      _item.putIfAbsent(
          foodId,
          () => OrderItem(
                id: DateTime.now().toString(),
                name: name,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }
}

import 'package:flutter/foundation.dart';
import 'package:uptrip/provider/carts.dart';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> foodOrder;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.foodOrder,
    @required this.dateTime,
  });
}

class Order with ChangeNotifier {
  List<OrderItem> _orderRegister = [];

  List<OrderItem> get item {
    return [..._orderRegister];
  }

  void addItem(List<CartItem> foodOrder, double total) {
    _orderRegister.insert(
        0,
        OrderItem(
          id: DateTime.now().toString(),
          amount: total,
          foodOrder: foodOrder,
          dateTime: DateTime.now(),
        ));
        notifyListeners();
  }
}

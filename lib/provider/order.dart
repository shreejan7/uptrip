import 'package:flutter/foundation.dart';
import 'package:uptrip/provider/carts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> setAndFetchOrderData() async {
    const url = 'https://uptrip-cef8f.firebaseio.com/order.json';
    final exportData = await http.get(url);
    final foodData = json.decode(exportData.body) as Map<String, dynamic>;
    if(foodData.isEmpty)
      return;
    print(json.decode(exportData.body));
    foodData.forEach((foodId, foodData) {
      
      _orderRegister.add(
        OrderItem(
          id: foodData['id'],
          amount: foodData['amount'],
          dateTime: DateTime.parse(foodData['dateTime']) ,
          foodOrder: (foodData['foodOrder'] as List<dynamic>).map((data)=>
            CartItem(
              id: data['id'],
              name: data['name'],
              price: data['price'],
              quantity: data['quantity'],

            ),
          ).toList(),
        ),
      );
      _orderRegister.reversed.toList(); 
    });
    notifyListeners();
  }

  Future<void> addItem(List<CartItem> foodOrder, double total) async {
    final url = 'https://uptrip-cef8f.firebaseio.com/order.json';
    final timestamp = DateTime.now();
    var responce = await http.post(url,
        body: json.encode({
          'amount': total,
          'foodOrder': foodOrder
              .map((value) => {
                    'id':value.id,
                    'name': value.name,
                    'price': value.price,
                    'quantity': value.quantity,
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String(),
        }));
    // _orderRegister.insert(
    //     0,
    //     OrderItem(
    //       id: json.decode(responce.body)['name'],
    //       amount: total,
    //       foodOrder: foodOrder,
    //       dateTime: timestamp,
    //     ));
    // notifyListeners();
  }
}

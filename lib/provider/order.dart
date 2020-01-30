import 'package:flutter/foundation.dart';
import 'package:uptrip/provider/carts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> foodOrder;
  final DateTime dateTime;
  final url;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.foodOrder,
    @required this.dateTime,
    @required this.url,
  });
}

class Order with ChangeNotifier {

  // final String authToken;
  // final String userId;
  // final String email;
  Order();
  List<OrderItem> _orderRegister = [];

  List<OrderItem> get item {
    return _orderRegister;
  }

  Future<void> setAndFetchOrderData( String userId ) async {
    String url = 'https://uptrip-cef8f.firebaseio.com/order/$userId.json';
    final exportData = await http.get(url);
    final foodData = json.decode(exportData.body) as Map<String, dynamic>;
    if(foodData.isEmpty)
      return;
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
              imgUrl: data['imgUrl'],
              resName: data['resName']


            ),
          ).toList(),
            url:foodData['imgUrl'],
        ),
      );
      _orderRegister.reversed.toList(); 
    });
    notifyListeners();
  }

  Future<void> addItem(List<CartItem> foodOrder, double total,String userId) async {
    final url = 'https://uptrip-cef8f.firebaseio.com/order/$userId.json';
    final timestamp = DateTime.now();
    await http.post(url,
        body: json.encode({
          'amount': total,
          'foodOrder': foodOrder
              .map((value) => {
                    'id':value.id,
                    'name': value.name,
                    'price': value.price,
                    'quantity': value.quantity,
                    'imgUrl':value.imgUrl,
                    'resName':value.resName,
                  })
              .toList(),
          'dateTime': timestamp.toIso8601String(),
          
        }));
    // final url = 'https://uptrip-cef8f.firebaseio.com/Resorder/${foodOrder.}.json';

    // await http.post(url,)
  }
}

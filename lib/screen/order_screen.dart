import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart' show Order;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrderScreen extends StatelessWidget {

  static const routeName= '/order-screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(title: Text('All order placed'),),
      body: ListView.builder(
        itemCount:orderData.item.length ,
        itemBuilder: (ctx,i)=> OrderItem(orderData.item[i],),
      ),
    );
  }
}
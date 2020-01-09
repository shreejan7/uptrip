import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart' show Order;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isloading = true;
  @override
  void initState() {
    Provider.of<Order>(
      context,
      listen: false,
    ).setAndFetchOrderData().then((_) {
      setState(() {
        _isloading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context);
    return _isloading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            drawer: DrawerApp(),
            appBar: AppBar(
              title: Text('All order placed'),
            ),
            body: ListView.builder(
              itemCount: orderData.item.length,
              itemBuilder: (ctx, i) => OrderItem(
                orderData.item[i],
              ),
            ),
          );
  }
}

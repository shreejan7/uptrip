import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/order.dart' show Order;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';
import '../provider/auth_user.dart';

class OrderScreen extends StatefulWidget {
  static const routeName = '/order-screen';

  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _isloading = true;
  @override
  void initState() {
    super.initState();
    final userId = Provider.of<AuthUser>(context, listen: false).userId;
    Provider.of<Order>(
      context,
      listen: false,
    ).setAndFetchOrderData(userId).catchError((v) {
      setState(() {
        _isloading = true;
      });
    }).then((_) {
      setState(() {
        _isloading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Order>(context, listen: false);
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text('All order placed'),
      ),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.item.length,
              itemBuilder: (ctx, i) => OrderItem(
                orderData.item[i],
              ),
            ),
    );
  }
}

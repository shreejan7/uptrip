import 'package:flutter/material.dart';
import '../screen/order_screen.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hey Traveller',
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.location_on,
            ),
            title: Text('Explore'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.payment
            ),
            title: Text('Payment'),
            onTap: () => Navigator.of(context).pushNamed(OrderScreen.routeName),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:uptrip/screen/food_item_screen.dart';
import '../screen/order_screen.dart';
import '../screen/restaurant_entry_screen.dart';

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
            leading: Icon(Icons.payment),
            title: Text('Payment'),
            onTap: () => Navigator.of(context).pushNamed(OrderScreen.routeName),
          ),
          Divider(),
        ListTile(
            leading: Icon(Icons.add),
            title: Text('Restaurant'),
            onTap: () => Navigator.of(context).pushNamed(RestaurantEntryScreen.routeName),
          ),
        ],
      ),
    );
  }
}

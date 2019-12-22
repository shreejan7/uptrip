import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/restaurants.dart';

class RestaurantDetailScreen extends StatelessWidget {
  static const routeName = '/restaurant-detail';
  @override
  Widget build(BuildContext context) {
    final restaurantId = ModalRoute.of(context).settings.arguments as String;
    final restaurant = Provider.of<Restaurants>(
      context,
      listen: false,
    ).findById(restaurantId);
    return Scaffold(
      appBar: AppBar(
        title: Text(restaurant.name),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/widgets/food_item.dart';
import '../provider/restaurants.dart';
import '../provider/foods.dart';
import '../provider/carts.dart';
import '../widgets/badge.dart';
import '../screen/all_cart_screen.dart';
import '../widgets/drawer.dart';



class FoodsOfRestaurantScreen extends StatelessWidget {
  static const routeName = '/foods-detail';
  @override
  Widget build(BuildContext context) {
    final restaurantId = ModalRoute.of(context).settings.arguments as String;
    final restaurant = Provider.of<Restaurants>(
      context,
      listen: false,
    ).findById(restaurantId);
    final food = Provider.of<Foods>(context);
    final foodItem = food.restaurantFood(restaurantId);

    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text(restaurant.name),
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.totalNumber.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.restaurant_menu,
              ),
              onPressed: () => 
                Navigator.of(context).pushNamed(AllCartScreen.routeName),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: foodItem.length,
        itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
          value: foodItem[i],
          child: FoodItem(),
        ),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }
}

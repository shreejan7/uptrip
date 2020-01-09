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
    Future<void> refresh() async {
      await Provider.of<Foods>(context, listen: false).fetchAndSetFoodsData();
    }

    final restaurantId = ModalRoute.of(context).settings.arguments as String;
    final restaurant = Provider.of<Restaurants>(
      context,
      listen: false,
    ).findById(restaurantId);
    // final food = Provider.of<Foods>(context);
    // final foodItem = food.restaurantFood(restaurantId);

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
      body: RefreshIndicator(
        onRefresh: refresh,
        child: FutureBuilder(
          future: Provider.of<Foods>(context,listen: false,).fetchAndSetFoodsData(),
          builder: (ctx, dataSnapshot) {
            if (dataSnapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (dataSnapshot.error != null) {
                return Center(
                  child: Text("There is some error"),
                );
              } else
                return Consumer<Foods>(
                  builder: (ctx, foodItem, child) => GridView.builder(
                    itemCount: foodItem.item.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: foodItem.item[i],
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
          },
        ),
      ),
    );
  }
}

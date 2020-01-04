import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/screen/foods_of_restaurant_screen.dart';
import '../screen/restaurant_detail_screen.dart';
import '../provider/restaurant.dart';
// import '../provider/order.dart';

class RestaurantItem extends StatelessWidget {
  // final String id;
  // final String name;
  // final String imgUrl;

  // RestaurantItem(this.id, this.name, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final restaurant = Provider.of<Restaurant>(context, listen: false);
    // final order = Provider.of<Order>(context, listen: false);

    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(
          RestaurantDetailScreen.routeName,
          arguments: restaurant.id),
      child: GridTile(
        child: Image.asset(
          'images/${restaurant.name}.jpg',
          fit: BoxFit.cover,
        ),
        footer: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTileBar(
            backgroundColor: Colors.black26,
            leading: Consumer<Restaurant>(
              builder: (ctx, restaurant, _) => IconButton(
                icon: Icon(
                  restaurant.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => restaurant.isfav(),
              ),
            ),
            title: Text(
              restaurant.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.restaurant_menu,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () =>
                  // order.addItem(restaurant.id, restaurant.name, 300),
                  Navigator.of(context).pushNamed(
                FoodsOfRestaurantScreen.routeName,
                arguments: restaurant.id,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

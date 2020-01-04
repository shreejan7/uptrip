import 'package:flutter/material.dart';
import './Restaurant_item.dart';
import '../provider/restaurants.dart';
import 'package:provider/provider.dart';

class AllRestaurantGrid extends StatelessWidget {
  final bool isFav;
  @override
  AllRestaurantGrid(this.isFav);
  Widget build(BuildContext context) {
    final restaurantData = Provider.of<Restaurants>(context);
    final restaurant = isFav ? restaurantData.fav : restaurantData.item;
    return GridView.builder(
      scrollDirection: Axis.vertical,
      // padding: const EdgeInsets.all(10.0),
      itemCount: restaurant.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: restaurant[i],
        child: RestaurantItem(
            // restaurant[i].id,
            // restaurant[i].name,
            // restaurant[i].imgUrl,
            ),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}

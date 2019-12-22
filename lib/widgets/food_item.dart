import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/food.dart';
import '../provider/order.dart';

class FoodItem extends StatelessWidget {
  // final String id;
  // final String name;
  // final String imgUrl;

  // foodItem(this.id, this.name, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Food>(context, listen: false);
    final order = Provider.of<Order>(context, listen: false);
    return Container(
      child: GridTile(
        child: Image.asset(
          'images/1.jpg',
          fit: BoxFit.cover,
        ),
       footer: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTileBar(
            backgroundColor: Colors.black26,
            leading: Consumer<Food>(
              builder: (ctx, food, _) => IconButton(
                icon: Icon(
                  food.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => food.isfav(),
              ),
            ),
            title: Text(
              food.name,
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
                  order.addItem(food.id, food.name, 300),
                 
            ),
          ),
        ),
      ),
    );
  }
}

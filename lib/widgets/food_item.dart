import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/food.dart';
import '../provider/carts.dart';

class FoodItem extends StatelessWidget {
  // final String id;
  // final String name;
  // final String imgUrl;

  // foodItem(this.id, this.name, this.imgUrl);

  @override
  Widget build(BuildContext context) {
    final food = Provider.of<Food>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      child: GridTile(
        child: Image.network(
          food.imgUrl,
          fit: BoxFit.cover,
        ),
        footer: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTileBar(
            backgroundColor: Colors.black26,
            leading: Consumer<Food>(
              builder: (ctx, food, _) => IconButton(
                icon: Icon(
                  food.isFavourite ? Icons.favorite : Icons.favorite_border,
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
                onPressed: () {
                      cart.addItem(food.id, food.name, food.price);
                      Scaffold.of(context).removeCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('${food.name} added to cart'),
                        duration: Duration(seconds: 2,),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: (){
                            cart.removeSingleItem(food.id);
                          },
                        ),
                      ));
                    }),
          ),
        ),
      ),
    );
  }
}

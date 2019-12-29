import 'package:flutter/material.dart';
import '../provider/carts.dart';
import 'package:provider/provider.dart';
import '../widgets/all_restaurant_grid.dart';
import '../widgets/badge.dart';
import '../widgets/drawer.dart';


class RestaurantOverviewScreen extends StatefulWidget {
  @override
  _RestaurantOverviewScreenState createState() =>
      _RestaurantOverviewScreenState();
}

enum favorite {
  seeAll,
  seeFav,
}

class _RestaurantOverviewScreenState extends State<RestaurantOverviewScreen> {
  @override
  bool isFav = false;

  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text('UpTrip'),
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
          onPressed: () =>{}
            ),
          ),
          PopupMenuButton(
            onSelected: (favorite value) {
              setState(() {
                if (value == favorite.seeFav)
                  isFav = true;
                else
                  isFav = false;
              });
            },
            icon: Icon(
              Icons.more_vert,
            ),
            itemBuilder: (ctx) => [
              PopupMenuItem(
                child: Text('see all'),
                value: favorite.seeAll,
              ),
              PopupMenuItem(
                child: Text('see Only favourite'),
                value: favorite.seeFav,
              ),
            ],
          )
        ],
      ),
      body: AllRestaurantGrid(isFav),
    );
    return scaffold;
  }
}

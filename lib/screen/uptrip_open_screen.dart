import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/restaurant_detail.dart';
// import 'package:uptrip/widgets/food_detail.dart';
// import '../provider/foods.dart';
import '../provider/order.dart';

// import './widgets/all_restaurant_grid.dart';
import '../widgets/badge.dart';
import './restaurant_overview_screen.dart';

enum favorite {
  seeAll,
  seeFav,
}

class UpTripOpenScreen extends StatefulWidget {
  @override
  _UpTripOpenScreenState createState() => _UpTripOpenScreenState();
}

class _UpTripOpenScreenState extends State<UpTripOpenScreen> {
  int id = 0;

  void changeLeftRestaurant() {
    setState(() {
      id += 1;
    });
  }

  void changeRightRestaurant() {
    setState(() {
      id -= 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final food = Provider.of<Foods>(context);
    // final itemRestaurant = restaurant.item;

    bool isFav = false;
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: Text('UpTrip'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: <Widget>[
          Consumer<Order>(
            builder: (_, order, ch) => Badge(
              child: ch,
              value: order.totalNumber.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.restaurant_menu,
              ),
              onPressed: () => {},
            ),
          ),
          IconButton(
            icon: Icon(Icons.grid_on),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RestaurantOverviewScreen(),
                )),
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
          ),
        ],
      ),
      // body: GridView.builder(
      //   itemCount: itemFood.length,
      //   itemBuilder: (ctx, i) => FoodDetail(itemFood[i].imgUrl),
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 3,
      //     childAspectRatio: 1,
      //     crossAxisSpacing: 4,
      //     mainAxisSpacing: 4,
      //   ),
      // ),

      body: RestaurantDetailAlignment(context),
    ));
  }
}

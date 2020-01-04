import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/screen/restaurant_dashboard.dart';
import '../provider/restaurants.dart';
import '../provider/restaurant.dart';
import '../widgets/drawer.dart';

import '../screen/foods_of_restaurant_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  static const routeName = '/restaurant-detail';

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  Future<void> _refersh() async {
    await Provider.of<Restaurants>(context).fetchAndSetRestaurantData();
  }

  @override
  Widget build(BuildContext context) {
    Restaurant restaurant;
    final restaurantId = ModalRoute.of(context).settings.arguments as String;
    setState(() {
      restaurant = Provider.of<Restaurants>(
        context,
      ).findById(restaurantId);
    });

    return Scaffold(
        drawer: DrawerApp(),
        appBar: AppBar(
          title: Text(restaurant.name),
          actions: <Widget>[
            FlatButton(
              child: Text('DashBoard'),
              onPressed: () => Navigator.of(context).pushNamed(
                RestaurantDashBoard.routeName,
                arguments: restaurantId,
              ),
            ),
          ],
        ),
        body: RefreshIndicator(
          onRefresh: _refersh,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Stack(
                        children: <Widget>[
                          Image.asset(
                            'images/${restaurant.name}.jpg',
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * 0.36,
                            width: double.infinity,
                          ),
                          new Container(
                            padding: new EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.28,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GridTileBar(
                                backgroundColor: Colors.black26,
                                leading: IconButton(
                                    icon: Icon(
                                      restaurant.isFavourite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        restaurant.isfav();
                                      });
                                    }),
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
                                          arguments: restaurant.id),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            Text(
                              restaurant.location,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(restaurant.description),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

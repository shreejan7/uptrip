import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/screen/restaurant_dashboard.dart';
import '../provider/restaurants.dart';
import '../provider/restaurant.dart';
import '../provider/foods.dart';
import 'package:location/location.dart';
import '../widgets/drawer.dart';

import '../screen/foods_of_restaurant_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  static const routeName = '/restaurant-detail';

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  bool isLoaded = false;
  double latitude;
  double longitude;
  Future<void> _refersh() async {
    final locationData = await Location().getLocation();
    latitude=locationData.latitude;
    longitude=locationData.longitude;
    await Provider.of<Restaurants>(context).fetchAndSetRestaurantData(latitude,longitude);
  }

  @override
  Widget build(BuildContext context) {
    @override
  
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
        body:isLoaded?Center(child: CircularProgressIndicator(),): RefreshIndicator(
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
                          Image.network(
                            restaurant.imgUrl,
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
                              restaurant.locationLatitude.toString()+
                              restaurant.locationLongitude.toString(),
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

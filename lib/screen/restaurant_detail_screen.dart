import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/widgets/drawer_restaurant_owner.dart';
import '../provider/restaurant.dart';
import '../screen/auth_screen.dart';
import '../provider/auth_user.dart';
import '../provider/restaurantData.dart';
import '../widgets/drawer.dart';
import '../screen/foods_of_restaurant_screen.dart';
import '../widgets/Restaurant_detail_each_grid.dart';

class RestaurantDetailScreen extends StatefulWidget {
  static const routeName = '/restaurant-detail';

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {
  @override
  void initState() {
    super.initState();
  }

  String userId;
  bool isLoaded = false;
  double latitude;
  double longitude;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthUser>(context, listen: false);
    final isAuth = Provider.of<AuthUser>(context, listen: false).isAuth;
    final resMail = Provider.of<AuthUser>(context, listen: false).resEmail;
    userId = Provider.of<AuthUser>(context, listen: false).userId;
    @override
    final restaurant = ModalRoute.of(context).settings.arguments as Restaurant;

    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              Container(
                  padding: EdgeInsets.only(left: 10.0),
                  height: MediaQuery.of(context).size.height * 0.5,
                  decoration: new BoxDecoration(
                    image: new DecorationImage(
                      image: new NetworkImage(restaurant.imgUrl),
                      fit: BoxFit.cover,
                    ),
                  )),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                padding: EdgeInsets.all(40.0),
                width: MediaQuery.of(context).size.width,
                decoration:
                    BoxDecoration(color: Color.fromRGBO(58, 66, 86, .2)),
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 120.0),
                      Icon(
                        Icons.restaurant,
                        color: Colors.white,
                        size: 40.0,
                      ),
                      Container(
                        width: 90.0,
                        child: new Divider(color: Colors.green),
                      ),
                      SizedBox(height: 10.0),
                      Text(
                        restaurant.name,
                        style: TextStyle(color: Colors.white, fontSize: 45.0),
                      ),
                      SizedBox(height: 30.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                              flex: 6,
                              child: Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    restaurant.location,
                                    maxLines: 1,
                                    style: TextStyle(color: Colors.white),
                                  ))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 8.0,
                top: 60.0,
                child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.arrow_back, color: Colors.white),
                ),
              )
            ],
          ),
          Expanded(
                      child: Container(
              height: MediaQuery.of(context).size.height * .2,
              width: MediaQuery.of(context).size.width,

              // color: Theme.of(context).primaryColor,
              padding: EdgeInsets.all(40.0),
              
                child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
      
                 child:
                    Text(
                      restaurant.description,
                      style: TextStyle(fontSize: 18.0),
                     
                    ),
                ),
              ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () => {
                Navigator.of(context).pushNamed( FoodsOfRestaurantScreen.routeName,
                arguments: restaurant,),
              },
              color: Color.fromRGBO(58, 66, 86, 1.0),
              child: Text("Go To Menu", style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }
}

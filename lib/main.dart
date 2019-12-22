import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/provider/order.dart';
import 'package:uptrip/provider/restaurants.dart';
import 'package:uptrip/screen/foods_of_restaurant_screen.dart';
import 'package:uptrip/screen/restaurant_detail_screen.dart';
import 'package:uptrip/screen/uptrip_open_screen.dart';
import './provider/foods.dart';


void main() => runApp(UpTrip());
class UpTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    
    return MultiProvider(
          providers:[
            ChangeNotifierProvider.value(
              value: Foods(),
          ),
          ChangeNotifierProvider.value(
              value: Restaurants(),
          ),ChangeNotifierProvider.value(
            value: Order(),
          ),
          // ChangeNotifierProvider.value(
          //   value: Food(),
          // ),
          ],
          child: MaterialApp(
          theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          // fontFamily: 'lato',
        ),
           
            home: new UpTripOpenScreen(),
            routes: {
              RestaurantDetailScreen.routeName:(ctx)=> RestaurantDetailScreen(),
              FoodsOfRestaurantScreen.routeName:(ctx)=>FoodsOfRestaurantScreen(),

            },
            
          ),
    );
  }
}
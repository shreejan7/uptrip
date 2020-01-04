import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/provider/order.dart';
import 'package:uptrip/screen/add_food_screen.dart';
import 'package:uptrip/screen/food_item_screen.dart';
import 'package:uptrip/screen/restaurant_entry_screen.dart';
import './provider/carts.dart';
import './provider/restaurants.dart';
import './screen/foods_of_restaurant_screen.dart';
import './screen/restaurant_detail_screen.dart';
import './screen/uptrip_open_screen.dart';
import './provider/foods.dart';
import './screen/all_cart_screen.dart';
import './screen/order_screen.dart';
import './screen/restaurant_dashboard.dart';
import './screen/edit_food_screen.dart';

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
          ),
          ChangeNotifierProvider.value(
              value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: Order(),
          )
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
              AllCartScreen.routeName:(_)=>AllCartScreen(),
              OrderScreen.routeName:(_)=>OrderScreen(),
              FoodItemScreen.routrName:(ctx)=>FoodItemScreen(),
              AddFoodScreen.routeName:(_)=>AddFoodScreen(),
              RestaurantEntryScreen.routeName:(ctx)=>RestaurantEntryScreen(),
              RestaurantDashBoard.routeName:(_)=>RestaurantDashBoard(),
              EditFoodScreen.routeName:(_)=>EditFoodScreen(),
            },
            
          ),
    );
  }
}
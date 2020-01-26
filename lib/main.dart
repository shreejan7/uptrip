import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/nearby_place.dart';
import './provider/restaurantData.dart';
import './provider/order.dart';
import './screen/add_food_screen.dart';
import './screen/food_item_screen.dart';
import './screen/restaurant_entry_screen.dart';
import './provider/carts.dart';
import './provider/restaurants.dart';
import './screen/foods_of_restaurant_screen.dart';
import './screen/restaurant_detail_screen.dart';
import './screen/uptrip_open_screen_user.dart';
import './provider/foods.dart';
import './screen/all_cart_screen.dart';
import './screen/order_screen.dart';
import './screen/edit_food_screen.dart';
import './screen/auth_screen.dart';
import './provider/auth_user.dart';
import './screen/restaurant_auth_screen.dart';
import './provider/auth_restaurant.dart';
import './provider/food_Data.dart';

void main() => runApp(UpTrip());
class UpTrip extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    
    return MultiProvider(
          providers:[
            ChangeNotifierProvider.value(
              value:AuthUser(),
            ),
            ChangeNotifierProxyProvider<AuthUser,Foods>(
              update:(ctx,auth,foodData)=>Foods(auth.token,auth.userEmail,foodData == null ? [] : foodData.item) ,
              create: null,
             
          ),
          ChangeNotifierProvider.value(
            value: AuthRestaurant(),
          ),
          ChangeNotifierProxyProvider<AuthUser,Restaurants>(
              update: (ctx,auth,restaurant)=>Restaurants(auth.token,auth.userId,auth.userEmail),
              create: null,
          ),
          ChangeNotifierProvider.value(
             value: Order(),
          ),
           
          ChangeNotifierProvider.value(
              value: Cart(),
          ),
          ChangeNotifierProvider.value(
            value: RestaurantData(),
          ),
          ChangeNotifierProvider.value(
            value: NearbyPlace(),
          )
          
          ],
          child: MaterialApp(
          theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),  
            home: new UpTripOpenScreenUser(),
            routes: {
              RestaurantDetailScreen.routeName:(ctx)=> RestaurantDetailScreen(),
              FoodsOfRestaurantScreen.routeName:(ctx)=>FoodsOfRestaurantScreen(),
              AllCartScreen.routeName:(_)=>AllCartScreen(),
              OrderScreen.routeName:(_)=>OrderScreen(),
              FoodItemScreen.routeName:(ctx)=>FoodItemScreen(),
              AddFoodScreen.routeName:(_)=>AddFoodScreen(),
              RestaurantEntryScreen.routeName:(ctx)=>RestaurantEntryScreen(),
              EditFoodScreen.routeName:(_)=>EditFoodScreen(),
              AuthScreen.routeName:(_)=>AuthScreen(),
              AuthRestaurantScreen.routeName:(_)=>AuthRestaurantScreen(),
            },            
          ),
    );
  }
}
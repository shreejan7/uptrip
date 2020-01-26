import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/provider/restaurant.dart';
import 'package:uptrip/widgets/food_item.dart';
import '../provider/foods.dart';
import '../provider/carts.dart';
import '../widgets/badge.dart';
import '../screen/all_cart_screen.dart';
import '../widgets/drawer.dart';

class FoodsOfRestaurantScreen extends StatefulWidget {
  static const routeName = '/foods-detail';

  @override
  _FoodsOfRestaurantScreenState createState() => _FoodsOfRestaurantScreenState();
}

class _FoodsOfRestaurantScreenState extends State<FoodsOfRestaurantScreen> {
   
  
  @override
  Widget build(BuildContext context) {
    Restaurant restaurant = ModalRoute.of(context).settings.arguments;
    print(restaurant.resName);
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text(restaurant.name.toString()),
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
              onPressed: () =>
                  Navigator.of(context).pushNamed(AllCartScreen.routeName),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Provider.of<Foods>(
          context,
          listen: false,
        ).fetchAndSetFoodsData(restaurant.resName),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (dataSnapshot.error != null) {
              print(dataSnapshot.error.toString());
              return Center(
                child: Text("There is some error"),
              );
            } else
            
              return 
              // RefreshIndicator(
              //   onRefresh: ()=>
              //   refresh(context),
                // child:
                 Consumer<Foods>(
                  builder: (ctx, foodItem, child) => GridView.builder(
                    itemCount: foodItem.item.length,
                    itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
                      value: foodItem.item[i],
                      child: FoodItem(),
                    ),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 3 / 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                  ),
                );
          }
        }
      ),
      
    );
  }
}

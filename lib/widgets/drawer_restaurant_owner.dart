import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/screen/foods_of_restaurant_screen.dart';
import '../provider/auth_user.dart';
import '../screen/auth_screen.dart';
import '../provider/restaurant.dart';
import 'package:uptrip/screen/add_food_screen.dart';
import '../screen/restaurant_detail_screen.dart';
import '../screen/food_item_screen.dart';


class DrawerRestaurantOwner extends StatelessWidget {
  final Restaurant restaurant;
  DrawerRestaurantOwner(this.restaurant);
   
  
  @override
  Widget build(BuildContext context) {
    String search;
   

    final isAuth = Provider.of<AuthUser>(context).isAuth;

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Welcome',
            ),
            automaticallyImplyLeading: false,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    search = value;
                  },
                ),
              ),
              IconButton(icon: Icon(Icons.search), onPressed: null),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.location_on,
            ),
            title: Text('Explore'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          if (isAuth)
            Divider(),
          if (isAuth)
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Detail Example'),
              onTap: () =>
                              Navigator.of(context).pushNamed(RestaurantDetailScreen.routeName,arguments: restaurant,),

            ),
          if (!isAuth)
            Divider(),
          // if (isAuth)
          //   ListTile(
          //     leading: Icon(Icons.add),
          //     title: Text('Restaurant'),
          //     onTap: () => Navigator.of(context)
          //         .pushNamed(RestaurantEntryScreen.routeName),
          //   ),
          if (!isAuth)
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Foods example"),
              onTap: () =>
                  Navigator.of(context).pushNamed(FoodsOfRestaurantScreen.routeName),
            ),
             if (isAuth)
            Divider(),
          if (isAuth)
            ListTile(
                leading: Icon(Icons.people),
                title: Text("Add food"),
                onTap: () {
                   Navigator.of(context).pushNamed(
              AddFoodScreen.routeName,arguments: restaurant,
            );
                }),
                 if (isAuth)
            Divider(),
          if (isAuth)
            ListTile(
                leading: Icon(Icons.people),
                title: Text("Edit food"),
                onTap: ()=>
                                Navigator.of(context).pushNamed(FoodItemScreen.routeName,arguments: restaurant),

                ),
          if (isAuth)
            Divider(),
          if (isAuth)
            ListTile(
                leading: Icon(Icons.people),
                title: Text("Logout"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<AuthUser>(context, listen: false).logout();
                }),
               
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/screen/foods_of_restaurant_screen.dart';
import '../screen/restaurant_detail_screen.dart';
import '../provider/restaurant.dart';
import '../screen/auth_screen.dart';
import '../provider/auth_user.dart';
// import '../provider/order.dart';

class RestaurantDetailEachGrid extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthUser>(context,listen: false);
    final isAuth = Provider.of<AuthUser>(context,listen: false).isAuth;


    final restaurant = Provider.of<Restaurant>(context, listen: false);
    // final order = Provider.of<Order>(context, listen: false);

    return GestureDetector(
      onTap: (){ Navigator.of(context).pushNamed(
          RestaurantDetailScreen.routeName,
          arguments: restaurant);
          print(restaurant.imgUrl);},
      child: GridTile(
        child: Image.network(
          restaurant.imgUrl,
          fit: BoxFit.cover,
        ),
        footer: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTileBar(
            backgroundColor: Colors.black26,
            leading: Consumer<Restaurant>(
              builder: (ctx, restaurant, _) => IconButton(
                icon: Icon(
                  restaurant.isFavourite
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: (){
                  if(isAuth)
                  restaurant.isfavorite(auth.token,auth.userId);

                  else
                    showDialog(
                      context: context,
                      builder: (ctx)=>AlertDialog(
                        title: Text('Not Login'),
                        content: Text('Login to favourite the Restaurnat.'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Login'),
                            onPressed: ()=>Navigator.of(context).pushNamed(AuthScreen.routeName),
                          ),
                          FlatButton(
                            child: Text('Not Now'),
                            onPressed: ()=> Navigator.of(context).pop(),
                          )
                        ],
                      )
                    );
                } 
              ),
            ),
            title: Text(
              restaurant.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                Icons.restaurant,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () =>
                  // order.addItem(restaurant.id, restaurant.name, 300),
                  Navigator.of(context).pushNamed(
                FoodsOfRestaurantScreen.routeName,
                arguments: restaurant,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

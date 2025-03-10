import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/restaurantData.dart';
import '../screen/foods_of_restaurant_screen.dart';
import '../screen/restaurant_detail_screen.dart';
import '../provider/auth_user.dart';


// import '../provider/foods.dart';

class RestaurantCardAlignment extends StatelessWidget {
  final int cardNum;

  RestaurantCardAlignment(this.cardNum);

  @override
  Widget build(BuildContext context) {

    final restaurant = Provider.of<RestaurantData>(context, listen: false);
    final restaurantItem = restaurant.item;
    print("This is res name "+restaurantItem[1].name.toString());
    
    // if (isFav == true) {
    //   print(cardNum);
    //   cardNum >= 3
    //       ? restaurantItem[cardNum - 3].isFavourite = true
    //       : restaurantItem[cardNum].isFavourite = false;
    // } else
    //   restaurantItem[cardNum].isFavourite = false;
    return GestureDetector(
       onTap: () => Navigator.of(context).pushNamed(
                  RestaurantDetailScreen.routeName,
                  arguments: restaurantItem[cardNum],
                  
                ),
          child: new Card(
        child: new Stack(
          children: <Widget>[
            new SizedBox.expand(
              child: new Material(
                borderRadius: new BorderRadius.circular(12.0),
                child: new Image.network(restaurantItem[cardNum].imgUrl, fit: BoxFit.cover),
                
              ),
            ),
            new SizedBox.expand(
              child: new Container(
                decoration: new BoxDecoration(
                    gradient: new LinearGradient(
                        colors: [Colors.transparent, Colors.black54],
                        begin: Alignment.center,
                        end: Alignment.bottomCenter)),
              ),
            ),
            new Align(
              alignment: Alignment.bottomLeft,
              child: new Container(
                  padding:
                      new EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
                  child: Consumer<RestaurantData>(
                    builder: (_, ctx, ch) => ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: GridTileBar(
              backgroundColor: Colors.black26,
              // leading: Consumer<Restaurants>(
              //   builder: (ctx, restaurant, _) => IconButton(
              //     icon: Icon(
              //       restaurantItem[cardNum].isFavourite
              //           ? Icons.favorite
              //           : Icons.favorite_border,
              //       color: Theme.of(context).accentColor,
              //     ),
              //     onPressed: () {
              //       set
              //     }
              //   ),
              // ),
              title: Text(
               restaurantItem[cardNum].name,
              // 'vdsfds',
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
                    Navigator.of(context).pushNamed(FoodsOfRestaurantScreen.routeName,arguments: restaurantItem[cardNum]),
                
              ),
            ),
          ),
                  )),
            )
          ],
        ),
      ),
    );
  }
}

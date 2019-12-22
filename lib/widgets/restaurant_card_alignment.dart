import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/restaurants.dart';

class RestaurantCardAlignment extends StatelessWidget {
  final int cardNum;
  final bool isFav;

  RestaurantCardAlignment(this.cardNum, this.isFav);

  @override
  Widget build(BuildContext context) {
    final restaurant = Provider.of<Restaurants>(context, listen: false);
    final restaurantItem = restaurant.item;
    if (isFav == true) {
      print(cardNum);
      cardNum >= 3
          ? restaurantItem[cardNum - 3].isFavourite = true
          : restaurantItem[cardNum].isFavourite = false;
    } else
      restaurantItem[cardNum].isFavourite = false;
    return new Card(
      child: new Stack(
        children: <Widget>[
          new SizedBox.expand(
            child: new Material(
              borderRadius: new BorderRadius.circular(12.0),
              child: new Image.asset('images/1.jpg', fit: BoxFit.cover),
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
                    new EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Consumer<Restaurants>(
                  builder: (_, ctx, ch) => new Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(restaurantItem[cardNum].name,
                          style: new TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w700)),
                      new Padding(padding: new EdgeInsets.only(bottom: 8.0)),
                      new Text(
                        restaurantItem[cardNum].description,
                        maxLines: 2,
                        textAlign: TextAlign.start,
                        style: new TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                )),
          )
        ],
      ),
    );
  }
}

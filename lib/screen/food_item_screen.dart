import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/provider/restaurant.dart';
import '../widgets/each_restaurant_food_item.dart';
import '../screen/add_food_screen.dart';
import '../provider/foods.dart';

class FoodItemScreen extends StatefulWidget {
  static const routeName = 'food-item-screen';

  @override
  _FoodItemScreenState createState() => _FoodItemScreenState();
}

bool isloading = false;

class _FoodItemScreenState extends State<FoodItemScreen> {
  Future<void> _refresh(BuildContext context) async {
    setState(() {
      isloading = true;
    });
    await Provider.of<Foods>(context, listen: false)
        .fetchAndSetFoods()
        .then((v) {
      print(v);
      if (v == 1) {
        setState(() {
          isloading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final restaurantId =
        ModalRoute.of(context).settings.arguments as Restaurant;
    final foodData = Provider.of<Foods>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Users food'),
        actions: <Widget>[
          IconButton(
            onPressed: () => Navigator.of(context)
                .pushNamed(AddFoodScreen.routeName, arguments: restaurantId),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: isloading
          ? Center(
              child: Text('fetcing data'),
            )
          : RefreshIndicator(
              onRefresh: () => _refresh(context),
              child: Padding(
                padding: EdgeInsets.all(8),
                child: ListView.builder(
                  itemCount: foodData.item.length,
                  itemBuilder: (_, i) => EachRestaurantFoodItem(
                    foodData.item[i].name,
                    foodData.item[i].imgUrl,
                    foodData.item[i].id,
                  ),
                ),
              ),
            ),
    );
  }
}

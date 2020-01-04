import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/each_restaurant_food_item.dart';
import '../screen/add_food_screen.dart';
import '../provider/foods.dart';

class FoodItemScreen extends StatelessWidget {
  Future<void> _refresh(BuildContext context) async{
    await Provider.of<Foods>(context).fetchAndSetFoodsData();
  }
  static const routrName = 'food-item-screen';
  @override
  Widget build(BuildContext context) {
    final restaurantId = ModalRoute.of(context).settings.arguments as String;
    final foodData = Provider.of<Foods>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Users food'),
        actions: <Widget>[
          IconButton(
            onPressed:()=> Navigator.of(context).pushNamed(AddFoodScreen.routeName,arguments: restaurantId),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: RefreshIndicator(
            onRefresh:()=> _refresh(context),
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

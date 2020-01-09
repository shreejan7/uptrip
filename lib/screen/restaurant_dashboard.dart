import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/screen/add_food_screen.dart';
import '../provider/foods.dart';
import './food_item_screen.dart';
import '../provider/restaurants.dart';
import '../provider/restaurant.dart';

class RestaurantDashBoard extends StatefulWidget {
  static const routeName = 'restaurant-dash-board';

  @override
  _RestaurantDashBoardState createState() => _RestaurantDashBoardState();
}

@override
class _RestaurantDashBoardState extends State<RestaurantDashBoard> {
  final key = GlobalKey<FormState>();
  var id;
  var _restaurant = new Restaurant(
    id: '',
    name: '',
    description: '',
    locationLatitude: 0.0,
    locationLongitude: 0.0,
    imgUrl: '',
  );
  void save() {
    // if (key.currentState.validate()) return;
    key.currentState.save();
    final restaurantData = Provider.of<Restaurants>(context);
    restaurantData.update(id, _restaurant);
    Navigator.of(context).pop();
  }

  final _nameFocus = FocusNode();

  bool check = true;
  bool value = true;
  void didChangeDependencies() {
    if (check)
      Provider.of<Foods>(context).fetchAndSetFoodsData().then((onValue) {
        setState(() {
          value = false;
        });
      });
    check = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    id = ModalRoute.of(context).settings.arguments as String;
    final restaurant =
        Provider.of<Restaurants>(context, listen: false).findById(id);
    _restaurant = new Restaurant(
      id: restaurant.id,
      name: restaurant.name,
      description: restaurant.description,
      locationLatitude: restaurant.locationLatitude,
      locationLongitude: restaurant.locationLongitude,
      imgUrl: restaurant.imgUrl,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome user'),
        actions: <Widget>[
          FlatButton(
            child: Text('Add foods'),
            onPressed: () => Navigator.of(context).pushNamed(
              AddFoodScreen.routeName,
              arguments: id,
            ),
          ),
          FlatButton(
            child: Text('Edit food'),
            onPressed: () => value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Navigator.of(context).pushNamed(FoodItemScreen.routrName),
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8),
        child: Form(
          key: key,
          child: ListView(
            children: <Widget>[
              TextFormField(
                initialValue: restaurant.name,
                decoration: InputDecoration(
                  labelText: 'Resataurant Name',
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value.isEmpty)
                    return 'Enter name with atleast 3 words';
                  else
                    return null;
                },
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_nameFocus);
                },
                onSaved: (value) {
                  _restaurant = new Restaurant(
                    id: _restaurant.id,
                    name: value,
                    description: _restaurant.description,
                    locationLatitude: _restaurant.locationLatitude,
                    locationLongitude: _restaurant.locationLongitude,
                    imgUrl: _restaurant.imgUrl,
                  );
                },
              ),
              TextFormField(
                initialValue: restaurant.description,
                decoration: InputDecoration(
                  labelText: 'Input description',
                ),
                textInputAction: TextInputAction.next,
                validator: (v) {
                  if (v.isEmpty)
                    return 'Enter some description of the restaurant';
                  else
                    return null;
                },
                maxLines: 5,
                focusNode: _nameFocus,
                onSaved: (value) {
                  _restaurant = new Restaurant(
                    id: _restaurant.id,
                    name: _restaurant.name,
                    description: value,
                         locationLatitude: _restaurant.locationLatitude,
                    locationLongitude: _restaurant.locationLongitude,
                    imgUrl: _restaurant.imgUrl,
                  );
                },
              ),
              // ImageInputRestaurantScreen(restaurant),
              Center(
                child: IconButton(
                  icon: Icon(Icons.save),
                  onPressed: save,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

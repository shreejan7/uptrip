import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/restaurant.dart';
import '../provider/restaurants.dart';

class RestaurantEntryScreen extends StatefulWidget {
  static const routeName = 'restaurant-entry-screen';

  @override
  _RestaurantEntryScreenState createState() => _RestaurantEntryScreenState();
}

class _RestaurantEntryScreenState extends State<RestaurantEntryScreen> {
  final key = GlobalKey<FormState>();
  var _restaurant = new Restaurant(
    id: '',
    name: '',
    description: '',
    location: 'kalanki',
    imgUrl: '',
  );
  void save() {
    // if (key.currentState.validate()) return;
    key.currentState.save();
    final restaurantData = Provider.of<Restaurants>(context);
    restaurantData.addRestaurant(_restaurant);
      Navigator.of(context).pop();
    }


  final _nameFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter Restaurant Detail'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: save,
          ),
        ],
      ),
      body: Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: key,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
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
                          location: _restaurant.location,
                          imgUrl: _restaurant.imgUrl,
                        );
                      },
                    ),
                    TextFormField(
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
                          location: _restaurant.location,
                          imgUrl: _restaurant.imgUrl,
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

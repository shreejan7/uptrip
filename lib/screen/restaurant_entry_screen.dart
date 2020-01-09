import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/input_location.dart';
import 'package:location/location.dart';
import '../provider/restaurant.dart';
import '../provider/restaurants.dart';
import '../widgets/image_input.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class RestaurantEntryScreen extends StatefulWidget {
  static const routeName = 'restaurant-entry-screen';

  @override
  _RestaurantEntryScreenState createState() => _RestaurantEntryScreenState();
}

class _RestaurantEntryScreenState extends State<RestaurantEntryScreen> {
  bool _isLoading = false;
  File _image;
  double latitude;
  double longitude;
  final key = GlobalKey<FormState>();
  var _restaurant = new Restaurant(
    id: '',
    name: '',
    description: '',
    locationLatitude: 0.0,
    locationLongitude: 0.0,
    imgUrl: '',
  );
    Future<void> inputUserLocation() async{
    final locationData = await Location().getLocation();
    print(locationData.latitude);
    print(locationData.longitude);
    latitude = locationData.latitude;
    longitude = locationData.longitude;

  }
  Future<void> save() async {
    setState(() {
      _isLoading = true;
    });
    key.currentState.save();
    final restaurantData = Provider.of<Restaurants>(context);
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://uptrip-cef8f.appspot.com');
    String filepath = 'restaurants/${_restaurant.name}.jpg';
    StorageUploadTask _uploadTask;
    setState(() {
      _uploadTask = _storage.ref().child(filepath).putFile(_image);
    });
    await _uploadTask.onComplete;
    _storage.ref().child(filepath).getDownloadURL().then((url) {
      _restaurant = new Restaurant(
        id: _restaurant.id,
        name: _restaurant.name,
        description: _restaurant.description,
        locationLatitude:latitude,
        locationLongitude: longitude,
        imgUrl: url,
      );
      restaurantData.addRestaurant(_restaurant);
      Navigator.of(context).pop();
    });
  }

  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();

  void dispose() {
    _nameFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  void _imageInput(File image) {
    setState(() {
      _image = image;
    });
  }

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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(8),
              child: Form(
                key: key,
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
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
                          locationLatitude: _restaurant.locationLatitude,
                          locationLongitude: _restaurant.locationLongitude,
                          imgUrl: _restaurant.imgUrl,
                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
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
                      maxLines: 9,
                      focusNode: _nameFocus,
                      onFieldSubmitted: (val) {
                        FocusScope.of(context).nextFocus();
                      },
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
                    SizedBox(
                      height: 30,
                    ),
                    ImageInput(_imageInput),
                    InputLocation(inputUserLocation),
                  ],
                ),
              ),
            ),
    );
  }
}

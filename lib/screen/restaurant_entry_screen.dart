import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/widgets/drawer_restaurant_owner.dart';
import '../widgets/input_location.dart';
import '../provider/restaurant.dart';
import '../provider/restaurants.dart';
import '../widgets/image_input.dart';
import 'dart:io';
import '../provider/auth_user.dart';
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
    location: '',
    resName:'',
  );
  String placeName;
    Future<String> inputUserLocation() async{
    final addressPoint = await Location().getLocation();
    latitude = addressPoint.latitude;
    longitude = addressPoint.longitude;
   Coordinates coordinate = new Coordinates(addressPoint.latitude, addressPoint.longitude);
  final addresses = await Geocoder.local.findAddressesFromCoordinates(coordinate);
    return addresses.first.addressLine.toString();
    // print(imageUrl);
  }
    String idRes;

  bool check=false;
  Future<void> save() async {
    setState(() {
      _isLoading = true;
    });
    key.currentState.save();
    final desc=_restaurant.description;
    final restaurantData = Provider.of<Restaurants>(context,listen: false);
    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://uptrip-cef8f.appspot.com');
    String filepath = 'restaurants/${_restaurant.resName}/${_restaurant.name}.jpg';
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
        location: _restaurant.location,
        resName: _restaurant.resName,
      );
      final email= Provider.of<AuthUser>(context,listen: false).userEmail;
     

      final urlEmail = email.replaceAll(RegExp(r'[^\w\s]+'),''); 
      restaurantData.addRestaurant(_restaurant,urlEmail,desc,idRes).then((_){
         setState(() {
           check = true;
      _isLoading = false;
      Navigator.of(context).pushReplacementNamed("/");
    });
      });
    });
  }

  final _nameFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageFocusNode = FocusNode();

  void dispose() {
    _nameFocus.dispose();
    _descriptionFocus.dispose();
    _imageFocusNode.dispose();
    super.dispose();
  }

  void _imageInput(File image) {
    setState(() {
      _image = image;
    });
  }
  @override
  Widget build(BuildContext context) {
    final data =ModalRoute.of(context).settings.arguments as Map<String,dynamic>;
    data.forEach((id,eachData) {

      _restaurant = new Restaurant(
              id: id,
            name: eachData['restaurantName'],
            description: eachData['description'],
            locationLatitude: 1.2,
            locationLongitude: 1.2,
            imgUrl: eachData['imgUrl'],
            location: eachData['location'],
            resName:eachData['forRestaurant'],
            );
    
            idRes = id;
    });

    return Scaffold(
       drawer:DrawerRestaurantOwner(_restaurant) ,
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
                      initialValue:_restaurant.name,
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
                          location: _restaurant.location,
                                  resName: _restaurant.resName,

                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      initialValue: _restaurant.description,
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
                        FocusScope.of(context).requestFocus(_imageFocusNode);
                  
                      },
                      onSaved: (value) {
                        _restaurant = new Restaurant(
                          id: _restaurant.id,
                          name: _restaurant.name,
                          description: value,
                          locationLatitude: _restaurant.locationLatitude,
                          locationLongitude: _restaurant.locationLongitude,
                          imgUrl: _restaurant.imgUrl,
                          location: _restaurant.location,
                                  resName: _restaurant.resName,

                        );
                      },
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Focus(focusNode: _imageFocusNode,
                      child: ImageInput(_imageInput,_restaurant.imgUrl)),
                    InputLocation(inputUserLocation,),
                  ],
                ),
              ),
            ),
    );
  }
}

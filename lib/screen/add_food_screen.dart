import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/provider/food.dart';
import 'package:uptrip/provider/restaurant.dart';
import 'package:uptrip/screen/restaurant_detail_screen.dart';
import 'package:uptrip/widgets/image_input.dart';
import '../provider/foods.dart';

class AddFoodScreen extends StatefulWidget {
  static const routeName = 'add-page';
  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _food = new Food(
    id: '',
    name: '',
    description: '',
    restaurantId: '',
    imgUrl: '',
    price: null,
  );
  String _initValue;
  var forEdit = true;
  bool forEditChange = false;
  bool isSubmit = false;
   Restaurant restaurantId;
  @override
  void didChangeDependencies() {
    if (forEdit) {
       restaurantId = ModalRoute.of(context).settings.arguments;
      forEdit = false;
    }
    super.didChangeDependencies();
  }

  File _image;
  Future<void> _save() async {
    final food = Provider.of<Foods>(context, listen: false);

    isSubmit = true;
    final isValidate = _form.currentState.validate();
    if (!isValidate) return;
    _form.currentState.save();

    final FirebaseStorage _storage =
        FirebaseStorage(storageBucket: 'gs://uptrip-cef8f.appspot.com');
    String filepath = 'foods/${restaurantId.resName}/${_food.name}.jpg';
  
    StorageUploadTask _uploadTask ;
    setState(() {
         _uploadTask = _storage.ref().child(filepath).putFile(_image);
     
    });
    await _uploadTask.onComplete;
    _storage.ref().child(filepath).getDownloadURL().then((url) {
      _food = Food(
        id: _food.id,
        restaurantId: _food.restaurantId,
        isFavourite: _food.isFavourite,
        name: _food.name,
        description: _food.description,
        imgUrl: url,
        price: _food.price,
      );
      food.addFood(_food).
      catchError((error) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: Text('An error has occured!'),
                  content: Text('Something went wrong'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Ok'),
                    )
                  ],
                ));
      }).
      then((_) {
        setState(() {
          isSubmit = true;
        });
         Navigator.of(context).pushNamed(RestaurantDetailScreen.routeName,arguments: restaurantId);
      });
    });
  }

  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _imageInput(File image) {
    setState(() {
      _image = image;
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add food'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _save,
          ),
        ],
      ),
      body: isSubmit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Title',
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (v) {
                        if (v.isEmpty || v.length < 3)
                          return 'Enter title more than 2 words';
                        else
                          return null;
                      },
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_priceFocusNode),
                      onSaved: (v) => _food = Food(
                        name: v,
                        description: _food.description,
                        id: _food.id,
                        restaurantId: _initValue,
                        isFavourite: _food.isFavourite,
                        imgUrl: _food.imgUrl,
                        price: _food.price,
                      ),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Price',
                      ),
                      validator: (value) {
                        if (value.isEmpty || double.parse(value) < 1)
                          return 'Enter price more than 0';
                        else
                          return null;
                      },
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) => FocusScope.of(context)
                          .requestFocus(_descriptionFocusNode),
                      onSaved: (v) => _food = Food(
                        name: _food.name,
                        description: _food.description,
                        id: _food.id,
                        restaurantId: _food.restaurantId,
                        isFavourite: _food.isFavourite,
                        imgUrl: _food.imgUrl,
                        price: double.parse(v),
                      ),
                    ),
                    SizedBox(height: 30,),
                    TextFormField(
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 5,
                      // keyboardType: TextInputType.text,
                      focusNode: _descriptionFocusNode,
                      onFieldSubmitted: (v){
                        FocusScope.of(context).nextFocus();
                      },
                      onSaved: (v) => _food = Food(
                        id: _food.id,
                        restaurantId: _food.restaurantId,
                        isFavourite: _food.isFavourite,
                        name: _food.name,
                        description: v,
                        imgUrl: _food.imgUrl,
                        price: _food.price,
                      ),
                    ),
                    SizedBox(height: 30,),
                    ImageInput(_imageInput,""),
                  ],
                ),
              ),
            ),
    );
  }
}
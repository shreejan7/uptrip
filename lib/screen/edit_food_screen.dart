import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/provider/food.dart';
import '../provider/foods.dart';

class EditFoodScreen extends StatefulWidget {
  static const routeName = 'edit-page';
  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();
  var _food = new Food(
    id: '',
    name: '',
    description: '',
    restaurantId: '',
    imgUrl:
        'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
    price: null,
  );
 
  var forEdit = true;
  bool isSubmit = false;
  @override
  void didChangeDependencies() {
    if (forEdit) {
      final foodId = ModalRoute.of(context).settings.arguments as String;

      if (foodId != null) {
         _food = Provider.of<Foods>(context, listen: false).findById(foodId);
        
      }
      forEdit = false;
    }
    super.didChangeDependencies();
  }

  void _save() {
    isSubmit = true;
    final isValidate = _form.currentState.validate();
    final foodId = ModalRoute.of(context).settings.arguments as String;

    if (!isValidate) return;
    _form.currentState.save();
    final food = Provider.of<Foods>(context, listen: false);
    food.upDateFood(foodId, _food);
    setState(() {
      isSubmit = true;
    });
    Navigator.of(context).pop();
  }

  void dispose() {
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit food'),
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
                      initialValue: _food.name,
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
                        restaurantId: _food.restaurantId,
                        isFavourite: _food.isFavourite,
                        imgUrl:
                            'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
                        price: _food.price,
                      ),
                    ),
                    TextFormField(
                      initialValue: _food.price.toString(),
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
                        imgUrl:
                            'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
                        price: double.parse(v),
                      ),
                    ),
                    TextFormField(
                      initialValue: _food.description,
                      decoration: InputDecoration(
                        labelText: 'Description',
                      ),
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      focusNode: _descriptionFocusNode,
                      onSaved: (v) => _food = Food(
                        id: _food.id,
                        restaurantId: _food.restaurantId,
                        isFavourite: _food.isFavourite,
                        name: _food.name,
                        description: v,
                        imgUrl:
                            'https://goodfoodnepal.com/wp-content/uploads/2018/05/buffmomo-150.jpg',
                        price: _food.price,
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

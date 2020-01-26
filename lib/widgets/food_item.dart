import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/food.dart';
import '../provider/carts.dart';
import '../provider/auth_user.dart';
import '../screen/auth_screen.dart';

class FoodItem extends StatelessWidget {
  // final String id;
  // final String name;
  // final String imgUrl;

  // foodItem(this.id, this.name, this.imgUrl);

  void _notAuth(BuildContext context){
    showDialog(
      context: context,
      builder: (ctx)=>AlertDialog(
        title: Text("You are not logged in."),
        content: Text("Login to order"),
        actions: <Widget>[
          FlatButton(
            child: Text('Login'),
            onPressed: ()=>Navigator.of(context).pushNamed(AuthScreen.routeName),
          ),
          FlatButton(
            child: Text('Cancel'),
            onPressed: ()=>Navigator.of(context).pop(),
          )
        ],
      )
    );

  }
  @override
  Widget build(BuildContext context) {
    final isAuth = Provider.of<AuthUser>(context).isAuth;

    final food = Provider.of<Food>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return Container(
      child: GridTile(
        child: Image.network(
          food.imgUrl,
          fit: BoxFit.cover,
        ),
        footer: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: GridTileBar(
            backgroundColor: Colors.black26,
            leading: Consumer<Food>(
              builder: (ctx, food, _) => IconButton(
                icon: Icon(
                  food.isFavourite?Icons.favorite:Icons.favorite_border,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () => food.isfav(),
              ),
            ),
            title: Text(
              food.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: IconButton(
                icon: Icon(
                  Icons.restaurant_menu,
                  color: Theme.of(context).accentColor,
                ),
                onPressed: () {
                  cart.addItem(food.id, food.name, food.price,food.imgUrl);
                      Scaffold.of(context).removeCurrentSnackBar();
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text('${food.name} added to cart'),
                        duration: Duration(seconds: 2,),
                        action: SnackBarAction(
                          label: 'UNDO',
                          onPressed: (){
                            cart.removeSingleItem(food.id);
                          },
                        ),
                      ));
                      
                    }),
          ),
        ),
      ),
    );
  }
}

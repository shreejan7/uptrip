import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/foods.dart';
import '../screen/edit_food_screen.dart';

class EachRestaurantFoodItem extends StatelessWidget {
  final id;
  final title;
  final imgUrl;
  EachRestaurantFoodItem(this.title, this.imgUrl,this.id);

  @override
  Widget build(BuildContext context) {
    final foodData = Provider.of<Foods>(context,listen: false,);
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(title),
          leading: CircleAvatar(
            backgroundImage: NetworkImage(imgUrl),
          ),
          trailing: Container(
            width: 100,
            child: Row(
              children: <Widget>[
                 IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    Navigator.of(context).pushNamed(EditFoodScreen.routeName, arguments: id);
                  },
                  color: Theme.of(context).accentColor,
                ),
                
                Consumer<Foods>(
                  builder: (_,i,cn)=>
                                 IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                  
                      Scaffold.of(context).showSnackBar(SnackBar(
                        content:Text('Are you sure'),
                        action: SnackBarAction(
                          label: 'Yes',
                          onPressed:()=> foodData.deleteFood(id),
                        ),
                       ),);
                    },
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
        Divider(),
      ],
    );
  }
}

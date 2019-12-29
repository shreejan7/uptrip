import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/carts.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String foodId;
  CartItem(
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.foodId,
  );
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(
      context,
      listen: false,
    );
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          cart.removeItem(foodId);
        },
        key: ValueKey(id),
        background: Container(
          alignment: Alignment.centerRight,
          child: Icon(Icons.delete,color: Colors.white,),
          color: Colors.red,
        ),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              child: FittedBox(
                  child: Text(
                'Rs$price',
              )),
            ),
            Spacer(),
            Column(children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                ),
              ),
              Text((price * quantity).toString()),
            ]),
            IconButton(
              padding: EdgeInsetsDirectional.only(bottom: 15),
              onPressed: () => cart.removeQuantity(foodId),
              icon: Icon(Icons.minimize),
            ),
            Text("${(quantity)} x"),
            IconButton(
              padding: EdgeInsetsDirectional.only(bottom: 0),
              onPressed: () => cart.addQuantity(foodId),
              icon: Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/carts.dart' show Cart;
import '../widgets/cart_item.dart';
import '../provider/order.dart';
import '../widgets/drawer.dart';

class AllCartScreen extends StatefulWidget {
  static const routeName = '/all-cart-screen';

  @override
  _AllCartScreenState createState() => _AllCartScreenState();
}

class _AllCartScreenState extends State<AllCartScreen> {
  @override
  Widget build(BuildContext context) {
     Provider.of<Cart>(context ,listen: false);
    bool _order = false;

    // final cart=Provider.of<Cart>(context);
    return Scaffold(
        drawer: DrawerApp(),
        appBar: AppBar(
          title: Text('Totol Evaluation'),
        ),
        body: Consumer<Cart>(
          builder: (ctx, cart, _) => Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.all(15),
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Total',
                        style: TextStyle(fontSize: 20),
                      ),
                      Spacer(),
                      Chip(
                        label: Text('Rs ${cart.totalPrice}'),
                        backgroundColor: Theme.of(context).primaryColor,
                      ),
                      FlatButton(
                        onPressed: () => conformMessage(context).then((value) {
                          _order = value;
                          print(value);
                          if (_order)
                            setState(() {
                              Provider.of<Order>(context).addItem(
                                cart.item.values.toList(),
                                cart.totalPrice,
                              );
                              cart.remove();
                            });
                        }),
                        // onPressed: () {

                        // },

                        child: Text(
                          'ORDER NOW',
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: cart.totalNumber,
                  itemBuilder: (ctx, i) => CartItem(
                    cart.item.values.toList()[i].id,
                    cart.item.values.toList()[i].name,
                    cart.item.values.toList()[i].price,
                    cart.item.values.toList()[i].quantity,
                    cart.item.keys.toList()[i],
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

Future<bool> conformMessage(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          content: Text('Are you sure?'),
          actions: <Widget>[
            FlatButton(
              child: Text('yes'),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
            FlatButton(
              child: Text('no'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            )
          ],
        );
      });
}

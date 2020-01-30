import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/provider/auth_user.dart';
import '../provider/carts.dart' show Cart;
import '../widgets/cart_item.dart';
import '../provider/order.dart';
import '../widgets/drawer.dart';

class AllCartScreen extends StatelessWidget {
  static const routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
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
                    label: Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        color: Theme.of(context).primaryTextTheme.title.color,
                      ),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cart.item.length,
              itemBuilder: (ctx, i) => CartItem(
                cart.item.values.toList()[i].id,
                cart.item.values.toList()[i].name,
                cart.item.values.toList()[i].price,
                cart.item.values.toList()[i].quantity,
                cart.item.keys.toList()[i],
                cart.item.values.toList()[i].imgUrl,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}
String userId;
class _OrderButtonState extends State<OrderButton> {
  @override
  void initState() { 
    super.initState();
     userId = Provider.of<AuthUser>(context,listen: false).userId;
  }
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    
    print(userId);
    return FlatButton(
      child: _isLoading ? CircularProgressIndicator() : Text('ORDER NOW'),
      onPressed: (widget.cart.totalPrice <= 0 || _isLoading)
          ? null
          : () {
              showDialog(
                context: context,
                child: AlertDialog(
                  title: Text('Are you sure?'),
                  actions: <Widget>[
                    FlatButton(
                        child: Text('Yes'),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          await Provider.of<Order>(context, listen: false)
                              .addItem(
                            widget.cart.item.values.toList(),
                            widget.cart.totalPrice,
                            userId,
                          );
                          widget.cart.remove();
                          setState(() {
                            _isLoading = false;
                          });
                        Navigator.of(context).pop();
                        }),
                    FlatButton(
                      child: Text('No'),
                      onPressed: (){
                        Navigator.of(context).pop();

                      },
                    )
                  ],
                ),
              );
            },
      textColor: Theme.of(context).primaryColor,
    );
  }
}

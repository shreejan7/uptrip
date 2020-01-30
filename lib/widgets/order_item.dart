import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart' as ord;
import 'dart:math';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expand = false;

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text('Rs ${widget.order.amount}'),
              subtitle: Text(
                DateFormat('dd MM yyyy hh:mm').format(
                  widget.order.dateTime,
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                },
              ),
            ),
            if (_expand)
              Container(
                height: min(widget.order.foodOrder.length * 20.0 + 200, 280),
                child: ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: widget.order.foodOrder.length,
                  itemBuilder: (ctx, i) => Column (
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 40,
                        backgroundImage:
                            NetworkImage(widget.order.foodOrder[i].imgUrl),
                      ),
                      SizedBox(height: 10,),
                      Text(
                        widget.order.foodOrder[i].name,
                        style: TextStyle(
                          // color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 23,
                        ),
                      ),
                      SizedBox(height: 10,),

                      Text(
                        widget.order.foodOrder[i].quantity.toString() +
                            '   x   ' +
                            widget.order.foodOrder[i].price.toString(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ));
  }
}

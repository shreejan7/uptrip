import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_user.dart';
import '../screen/auth_screen.dart';
import '../screen/order_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../screen/restaurant_entry_screen.dart';

class DrawerApp extends StatefulWidget {
  @override
  _DrawerAppState createState() => _DrawerAppState();
}

class _DrawerAppState extends State<DrawerApp> {
  bool isLoading = false;
  bool resOwner = false;
  String email;
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthUser>(context, listen: false);
    auth.autoLogin().then((va) {
       email = auth.userEmail;
       if(email.contains('@uptrip')){
          resOwner = true;
  }
      setState(() {
        isLoading = true;
      });
    });
    return 
         ForDrawer(resOwner,email);
        
  }
}
Future<void> resOwner(BuildContext context, String email) async{
   final userEmail = email.replaceAll(RegExp(r'[^\w\s]+'),'');
  String url =
            'https://uptrip-cef8f.firebaseio.com/restaurantUsers.json?orderBy="forRestaurant"&equalTo="$userEmail"';
        var data = await http.get(url);
        Map<String,dynamic> dataAll = json.decode(data.body);
         Navigator.of(context).pushNamed(
              RestaurantEntryScreen.routeName,
              arguments: dataAll,
            );
}
class ForDrawer extends StatelessWidget {
  final String email;
  final bool resowner;
  ForDrawer(this.resowner,this.email);
   
  
  @override
  Widget build(BuildContext context) {
    String search;
   

    final isAuth = Provider.of<AuthUser>(context).isAuth;

    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              'Hey Traveller',
            ),
            automaticallyImplyLeading: false,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    search = value;
                  },
                ),
              ),
              IconButton(icon: Icon(Icons.search), onPressed: null),
            ],
          ),
          Divider(),
          ListTile(
            leading: Icon(
              Icons.location_on,
            ),
            title: Text('Explore'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          if (isAuth)
            Divider(),
          if (isAuth)
            ListTile(
              leading: Icon(Icons.payment),
              title: Text('Payment'),
              onTap: () =>
                  Navigator.of(context).pushNamed(OrderScreen.routeName),
            ),
          if (!isAuth)
            Divider(),
          // if (isAuth)
          //   ListTile(
          //     leading: Icon(Icons.add),
          //     title: Text('Restaurant'),
          //     onTap: () => Navigator.of(context)
          //         .pushNamed(RestaurantEntryScreen.routeName),
          //   ),
          if (!isAuth)
            ListTile(
              leading: Icon(Icons.people),
              title: Text("Login/Sign Up"),
              onTap: () =>
                  Navigator.of(context).pushNamed(AuthScreen.routeName),
            ),
          if (isAuth)
            Divider(),
          if (isAuth)
            ListTile(
                leading: Icon(Icons.people),
                title: Text("Logout"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushReplacementNamed('/');
                  Provider.of<AuthUser>(context, listen: false).logout();
                }),
                 if (resowner)
            ListTile(
                leading: Icon(Icons.people),
                title: Text("DashBoard"),
                onTap: () {
                  resOwner(context,email);
                }),
        ],
      ),
    );
  }
}

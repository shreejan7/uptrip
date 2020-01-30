import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../screen/Loading_screen.dart';
// import '../provider/nearby_place.dart';
import '../widgets/drawer.dart';
import '../widgets/restaurant_detail.dart';
import '../provider/carts.dart';
import '../screen/all_cart_screen.dart';
import '../widgets/badge.dart';
import './restaurant_overview_screen.dart';
import '../provider/restaurantData.dart';
import '../provider/auth_user.dart';
import 'package:geolocator/geolocator.dart';

 

enum favorite {
  seeAll,
  seeFav,
}

class UpTripOpenScreenUser extends StatefulWidget {
  @override
  _UpTripOpenScreenUserState createState() => _UpTripOpenScreenUserState();
}

class _UpTripOpenScreenUserState extends State<UpTripOpenScreenUser> {
  void _showError(String error) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Something went wrong'),
              content: (error ==
                      "NoSuchMethodError: The getter 'isEmpty' was called on null. Receiver: null Tried calling: isEmpty")
                  ? Text("no data exist")
                  : Text('Something went  wrong'),
            ));
  }

  Future<int> _checkGps() async {
    if (!(await Geolocator().isLocationServiceEnabled())) {
      return 0;
    } else
      return 1;
  }

  bool isTrue = true;
  bool loading = true;
  bool locationloading = false;
  var count;
  String userId;
  @override
  void initState() {
    super.initState();
    userId = Provider.of<AuthUser>(context, listen: false).userId;
    Provider.of<RestaurantData>(context, listen: false)
        .fetchNewRestaurantData(userId)
        .catchError((val) {
      _showError(val);
    }).then((val) {
      setState(() {
        count = val;
        loading = false;
      });
      print(val);
    });
  }

  bool emailTrue = false;
  @override
  Widget build(BuildContext context) {
    final isAuth = Provider.of<AuthUser>(context).isAuth;
    bool isFav;
    return loading
        ? Center(
            child: LoadingScreen(),
          )
        : Scaffold(
            drawer:DrawerApp(),
            appBar: AppBar(
              elevation: 0.0,
              title: Text('UpTrip'),
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
              actions: <Widget>[
                // IconButton(
                //   icon: Icon(Icons.check),
                //   onPressed: ()=>Provider.of<RestaurantData>(context,listen: false).findLocation(27.6881054, 85.2820128),
                // ),
                if (isAuth)
                  Consumer<Cart>(
                    builder: (_, cart, ch) => Badge(
                      child: ch,
                      value: cart.totalNumber.toString(),
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.restaurant_menu,
                      ),
                      onPressed: () => Navigator.of(context)
                          .pushNamed(AllCartScreen.routeName),
                    ),
                  ),
                IconButton(
                  icon: Icon(Icons.grid_on),
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RestaurantOverviewScreen(),
                      )),
                ),
                PopupMenuButton(
                  onSelected: (favorite value) {
                    setState(() {
                      if (value == favorite.seeFav)
                        isFav = true;
                      else
                        isFav = false;
                    });
                  },
                  icon: Icon(
                    Icons.more_vert,
                  ),
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: Text('see all'),
                      value: favorite.seeAll,
                    ),
                    PopupMenuItem(
                      child: Text('see Only favourite'),
                      value: favorite.seeFav,
                    ),
                  ],
                ),
              ],
            ),
            body: locationloading
                ? Center(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Column(
                    children: <Widget>[
                      Expanded(child: RestaurantDetailAlignment(context)),
                      FlatButton.icon(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.height * 0.05),
                        icon: Icon(
                          isTrue ? Icons.location_off : Icons.location_on,
                          color: Theme.of(context).primaryColor,
                        ),
                        label: Text(
                            isTrue ? 'Enable location' : 'location Enable',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor)),
                        onPressed: () {
                          setState(() {
                            locationloading = true;
                          });
                          _checkGps().then((v) {
                            print(v);
                            if (v == 0) {
                              showDialog(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text("location not enable"),
                                    content: Text("Please enable location"),
                                    actions: <Widget>[
                                      FlatButton(
                                          child: Text("Okay"),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                            Navigator.of(context)
                                                .pushReplacementNamed("/");
                                          })
                                    ],
                                  ));
                              return;
                            } else if (v == 1) {
                              Provider.of<RestaurantData>(context,
                                      listen: false)
                                  .fetchAndSetRestaurantData(userId)
                                  .catchError((va) {
                                // print(va);
                                showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                          title: Text('No data available'),
                                          content: Text(
                                              'There is no restaurant nearby'),
                                          actions: <Widget>[
                                            FlatButton(
                                                child: Text('New restaunrant'),
                                                onPressed: () {
                                                  setState(() {
                                                    locationloading = true;
                                                  });
                                                  Navigator.of(context).pop();
                                                  Provider.of<RestaurantData>(
                                                          context,
                                                          listen: false)
                                                      .fetchNewRestaurantData(
                                                          userId)
                                                      .then((val) {
                                                    setState(() {
                                                      locationloading = false;
                                                      // loading = false;
                                                    });
                                                    print("THis is val" +
                                                        val.toString());
                                                  });
                                                })
                                          ],
                                        ));
                              }).then((val) {
                                setState(() {
                                  count = val;
                                  isTrue = false;
                                  loading = false;
                                  locationloading = false;
                                });
                                print("THis is val" + val.toString());
                              });
                            }
                          });

                          // });

                          // Navigator.of(context).pop();
                        },
                      )
                    ],
                  ));
  }
}

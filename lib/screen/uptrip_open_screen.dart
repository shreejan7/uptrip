import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/drawer.dart';
import '../widgets/restaurant_detail.dart';
// import 'package:uptrip/widgets/food_detail.dart';
// import '../provider/foods.dart';
import '../provider/carts.dart';
import '../screen/all_cart_screen.dart';
import 'package:location/location.dart';
import '../widgets/badge.dart';
import './restaurant_overview_screen.dart';
import '../provider/restaurants.dart';

enum favorite {
  seeAll,
  seeFav,
}

class UpTripOpenScreen extends StatefulWidget {
  @override
  _UpTripOpenScreenState createState() => _UpTripOpenScreenState();
}

class _UpTripOpenScreenState extends State<UpTripOpenScreen> {
  double latitude;
  double longitude;
  bool isTrue = true;
  bool isLoaded = true;
  bool loading = true;
 Future<void> inputUserLocation() async{

    final locationData = await Location().getLocation();
    latitude=locationData.latitude;
    longitude=locationData.longitude;
    setState(() {
   loading = false;
      
    });

  }
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
    inputUserLocation();
    
    });
    Provider.of<Restaurants>(context,listen: false).fetchAndSetRestaurantData(latitude,longitude).then((_) {
        setState(() {
          isLoaded = false;
        });
      });
    super.initState();
  }
  @override
  void didChangeDependencies() {
    if (isTrue)
      
    super.didChangeDependencies();
    isTrue = false;
  }

  @override
  Widget build(BuildContext context) {
    // final food = Provider.of<Foods>(context);
    // final itemRestaurant = restaurant.item;

    bool isFav;
    return Scaffold(
      drawer: DrawerApp(),
      appBar: AppBar(
        title: Text('UpTrip'),
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        actions: <Widget>[
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.totalNumber.toString(),
            ),
            child: IconButton(
              icon: Icon(
                Icons.restaurant_menu,
              ),
              onPressed: () =>
                  Navigator.of(context).pushNamed(AllCartScreen.routeName),
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
      // body: GridView.builder(
      //   itemCount: itemFood.length,
      //   itemBuilder: (ctx, i) => FoodDetail(itemFood[i].imgUrl),
      //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //     crossAxisCount: 3,
      //     childAspectRatio: 1,
      //     crossAxisSpacing: 4,
      //     mainAxisSpacing: 4,
      //   ),
      // ),

      body: isLoaded
          ? Center(
              child: CircularProgressIndicator(),
            )
         : loading
          ? Center(
              child: CircularProgressIndicator(),
            )
         :RestaurantDetailAlignment(context),
    );
  }
}

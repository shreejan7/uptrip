import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uptrip/widgets/drawer_restaurant_owner.dart';
import '../provider/restaurant.dart';
import '../screen/auth_screen.dart';
import '../provider/auth_user.dart';
import '../provider/restaurantData.dart';
import '../widgets/drawer.dart';
import '../screen/foods_of_restaurant_screen.dart';

class RestaurantDetailScreen extends StatefulWidget {
  
  static const routeName = '/restaurant-detail';

  @override
  _RestaurantDetailScreenState createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen> {

  @override
  void initState() { 
    super.initState();
  }
  String userId ;
  bool isLoaded = false;
  double latitude;
  double longitude;
  Future<void> _refersh() async {
    await Provider.of<RestaurantData>(context).fetchAndSetRestaurantData(userId);
  }
  @override
  Widget build(BuildContext context) {
      final auth = Provider.of<AuthUser>(context,listen: false);
    final isAuth = Provider.of<AuthUser>(context,listen: false).isAuth;
    final resMail = Provider.of<AuthUser>(context,listen: false).resEmail;
        // final token = Provider.of<AuthUser>(context,listen: false).token;
     userId = Provider.of<AuthUser>(context,listen: false).userId;
    @override

        final restaurant =ModalRoute.of(context).settings.arguments as Restaurant;

    return Scaffold(
      
        drawer:resMail?DrawerRestaurantOwner(restaurant):DrawerApp(),
        appBar: AppBar(
          title: Text(restaurant.name),
          centerTitle: true,
          
        ),
        body:isLoaded?Center(child: CircularProgressIndicator(),): RefreshIndicator(
          onRefresh: _refersh,
          child: ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Card(
                      child: Stack(
                        children: <Widget>[
                          Image.network(
                            restaurant.imgUrl,
                            fit: BoxFit.fill,
                            height: MediaQuery.of(context).size.height * 0.36,
                            width: double.infinity,
                          ),
                          new Container(
                            padding: new EdgeInsets.only(
                              top: MediaQuery.of(context).size.height * 0.28,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: GridTileBar(
                                backgroundColor: Colors.black26,
                                leading: IconButton(
                                    icon: Icon(
                                      restaurant.isFavourite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Theme.of(context).accentColor,
                                    ),
                                    onPressed: () {
                  if(isAuth)
                  restaurant.isfav(auth.token,auth.userId);
                  else
                    showDialog(
                      context: context,
                      builder: (ctx)=>AlertDialog(
                        title: Text('Not Login'),
                        content: Text('Login to favourite the Restaurnat.'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Login'),
                            onPressed: ()=>Navigator.of(context).pushNamed(AuthScreen.routeName),
                          ),
                          FlatButton(
                            child: Text('Not Now'),
                            onPressed: ()=> Navigator.of(context).pop(),
                          )
                        ],
                      )
                    );
                } ),
                                title: Text(
                                  restaurant.name,
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
                                  onPressed: () =>
                                      // order.addItem(restaurant.id, restaurant.name, 300),
                                      Navigator.of(context).pushNamed(
                                          FoodsOfRestaurantScreen.routeName,
                                          arguments: restaurant),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  restaurant.name,
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                                IconButton(
                                  alignment: Alignment.bottomLeft,
                                  icon: Icon(Icons.star_border),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                            Text(
                              restaurant.location,
                            ),
                          ],
                        ),
                      ],
                    ),
                    Divider(
                      thickness: 3,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Text(restaurant.description),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

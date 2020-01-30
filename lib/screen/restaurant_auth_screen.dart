import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/httperror_delete.dart';
import '../provider/auth_restaurant.dart';

class AuthRestaurantScreen extends StatelessWidget {
  static const routeName = '/auth-restaurant';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: AuthCard()),
    );
  }
}

class AuthCard extends StatefulWidget {
  AuthCard();
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  Map<String, String> _authData = {
    'RestaurantName': '',
    'OwnerName': '',
    'RestaurantRegisterId': '',
    'PhoneNumber': '',
    'Email': '',
    'REmail': '',
    'password': '',
  };
  var _isLoading = false;
  final _passwordController = TextEditingController();
  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text('Something went wrong'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () => Navigator.of(ctx).pop(),
                )
              ],
            ));
  }

  final _formKey = GlobalKey<FormState>();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<AuthRestaurant>(
        context,
        listen: false,
      ).signUpRestaurant(
        _authData['RestaurantName'],
        _authData['OwnerName'],
        _authData['RestaurantRegisterId'],
        _authData['PhoneNumber'],
        _authData['Email'],
        _authData['REmail'],
        _authData['password'],
      );
    } on HttpError catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      _showErrorDialog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      _showErrorDialog(errorMessage);
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 8.0,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        width: deviceSize.width * 0.85,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                    decoration: InputDecoration(labelText: 'Restaurant Name'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty || value.length < 3) {
                        return 'Invalid Restaurant!';
                      }
                    },
                    onSaved: (value) {
                      _authData['RestaurantName'] = value;
                    }),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Owner Name'),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty || value.length < 3) {
                        return 'Invalid Restaurant!';
                      }
                    },
                    onSaved: (value) {
                      _authData['OwnerName'] = value;
                    }),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Restaurant register ID'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Invalid registerId!';
                    }
                  },
                  onSaved: (value) {
                    _authData['RestaurantRegisterId'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value.isEmpty || value.length < 3) {
                      return 'Invalid Phone Number!';
                    }
                  },
                  onSaved: (value) {
                    _authData['PhoneNumber'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'E-Mail'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['Email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Restaurant E-Mail(restaurant@uptrip.com)'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@uptrip')) {
                      return 'Invalid restaurant email!';
                    }
                  },
                  onSaved: (value) {
                    _authData['REmail'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                TextFormField(
                    decoration: InputDecoration(labelText: 'Confirm Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match!';
                      }
                    }),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child: Text('SIGN UP'),
                    onPressed: _submit,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 8.0),
                    color: Theme.of(context).primaryColor,
                    textColor: Theme.of(context).primaryTextTheme.button.color,
                  ),
                FlatButton(
                  child: Text('NOT A RESTAURANT OWNER?'),
                  onPressed: () => showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                            content: Text('Sign up as user instead?'),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Yes'),
                                onPressed: null,
                              ),
                              FlatButton(
                                child: Text('No'),
                                onPressed: () => Navigator.of(context).pop(),
                              )
                            ],
                          )),
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

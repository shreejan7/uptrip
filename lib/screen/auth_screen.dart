
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/httperror_delete.dart';
import '../provider/auth_user.dart';
import './restaurant_auth_screen.dart';
import '../screen/restaurant_entry_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum AuthMode { Signup, Login }

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(child: AuthCard()),
    );
  }
}

class AuthCard extends StatefulWidget {
  @override
  _AuthCardState createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  final TextEditingController _textController = new TextEditingController();
  final TextEditingController _textController1 = new TextEditingController();
  final TextEditingController _textController2 = new TextEditingController();
  final TextEditingController _textController3 = new TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
    'firstName': '',
    'lastName': '',
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
      if (_authMode == AuthMode.Login) {
        await Provider.of<AuthUser>(
          context,
          listen: false,
        ).signInUser(_authData['email'], _authData['password']);
        final isAuth = Provider.of<AuthUser>(context, listen: false).isAuth;
        final token = Provider.of<AuthUser>(context, listen: false).token;
        String email = _authData['email'];
        final userEmail = email.replaceAll(RegExp(r'[^\w\s]+'), '');
        String url =
            'https://uptrip-cef8f.firebaseio.com/restaurantUsers.json?orderBy="forRestaurant"&equalTo="$userEmail"';
        var data = await http.get(url);
        Map<String,dynamic> dataAll = json.decode(data.body);
        print(dataAll);
        if (isAuth) {
          _passwordController.clear();
          _textController.clear();
          _textController1.clear();
          _textController2.clear();
          _textController3.clear();
          if (_authData['email'].contains('@uptrip')) {
            Navigator.of(context).pushNamed(
              RestaurantEntryScreen.routeName,
              arguments: dataAll,
            );
          } else
            Navigator.of(context).pushReplacementNamed('/');
        }
      } else {
        await Provider.of<AuthUser>(
          context,
          listen: false,
        ).signUpUser(_authData['email'], _authData['password'],
            _authData['firstName'], _authData['lastName']);
      }
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
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
    }
    _passwordController.clear();
    _textController.clear();
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
        height: _authMode == AuthMode.Signup
            ? MediaQuery.of(context).size.height * 0.65
            : 320,
        constraints:
            BoxConstraints(minHeight: _authMode == AuthMode.Signup ? 320 : 260),
        width: deviceSize.width * 0.75,
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(labelText: 'First Name',suffixIcon: Icon(Icons.people_outline)),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value.isEmpty || value.length < 3) {
                          return 'Invalid FirstName!';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _authData['firstName'] = value;
                        value = null;
                      }),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    controller: _textController1,
                    decoration: InputDecoration(labelText: 'Last Name',suffixIcon: Icon(Icons.people_outline),),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty || value.length < 3) {
                        return 'Invalid lastName!';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      _authData['firstName'] = value;
                      value = null;
                    },
                  ),
                TextFormField(
                  controller: _textController2,
                  decoration: InputDecoration(labelText: 'E-Mail',suffixIcon: Icon(Icons.mail,) , ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty || !value.contains('@')) {
                      return 'Invalid email!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['email'] = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Password',suffixIcon: Icon(Icons.remove_red_eye)),
                  obscureText: true,
                  controller: _passwordController,
                  validator: (value) {
                    if (value.isEmpty || value.length < 5) {
                      return 'Password is too short!';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _authData['password'] = value;
                  },
                ),
                if (_authMode == AuthMode.Signup)
                  TextFormField(
                    controller: _textController3,
                    enabled: _authMode == AuthMode.Signup,
                    decoration: InputDecoration(labelText: 'Confirm Password',suffixIcon: Icon(Icons.remove_red_eye)),
                    obscureText: true,
                    validator: _authMode == AuthMode.Signup
                        ? (value) {
                            if (value != _passwordController.text) {
                              return 'Passwords do not match!';
                            }
                            return null;
                          }
                        : null,
                  ),
                SizedBox(
                  height: 20,
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  RaisedButton(
                    child:
                        Text(_authMode == AuthMode.Login ? 'LOGIN' : 'SIGN UP',),
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
                  child: Text(
                      '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD'),
                  onPressed: _switchAuthMode,
                  padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  textColor: Theme.of(context).primaryColor,
                ),
                if (_authMode == AuthMode.Signup)
                  FlatButton(
                    child: Text('DO YOU HAVE A RESTAURANT?'),
                    onPressed: () => showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                              content: Text('Sign up for restaurant instead?'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () => Navigator.of(context)
                                      .pushNamed(
                                          AuthRestaurantScreen.routeName),
                                ),
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () => Navigator.of(context).pop(),
                                )
                              ],
                            )),
                    padding:
                        EdgeInsets.symmetric(horizontal: 30.0, vertical: 4),
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

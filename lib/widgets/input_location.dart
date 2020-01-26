import 'package:flutter/material.dart';

class InputLocation extends StatefulWidget {
  final Function userLocationInput;
  InputLocation(
    this.userLocationInput,
  );
  @override
  _InputLocationState createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  String placeName = 'a';

  @override
  Widget build(BuildContext context) {
    // String url='https://maps.googleapis.com/maps/api/staticmap?center=&27.6881131,85.282046&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C27.6881131,85.282046&key=AIzaSyDZrs6bMG5DztNhn9CqflCIb7YFmrbywZg';
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        Container(
          padding: EdgeInsetsDirectional.only(
            top: 10,
            bottom: 10,
          ),
          decoration: BoxDecoration(border: Border.all(width: 1)),
          // height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          alignment: Alignment.topCenter,
          child: placeName == 'a'
              ? Text(
                  'No location selected',
                  textAlign: TextAlign.center,
                )
              : Text(
                  placeName,
                  textAlign: TextAlign.center,
                ),
        ),
        FlatButton.icon(
            icon: Icon(
              Icons.location_on,
              color: Theme.of(context).primaryColor,
            ),
            label: Text(
              'Current location',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
            onPressed: () async {
              String imageUrl = await widget.userLocationInput();
              setState(() {
                placeName = imageUrl;
                print("This is url ff=" + placeName);
              });
            }),
      ],
    );
  }
}

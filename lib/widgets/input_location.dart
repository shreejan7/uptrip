import 'package:flutter/material.dart';


class InputLocation extends StatefulWidget {
  
 final Function userLocationInput;
  InputLocation(this.userLocationInput);
  @override
  _InputLocationState createState() => _InputLocationState();
}

class _InputLocationState extends State<InputLocation> {
  
  String _mapUrl;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          width: double.infinity,
          alignment: Alignment.center,
          child: _mapUrl==null
              ? Text(
                  'No location selected',
                  textAlign: TextAlign.center,
                )
              : Image.network(_mapUrl,fit: BoxFit.cover,),
        ),
        Row(
          children: <Widget>[
            FlatButton.icon(
              icon: Icon(Icons.location_on),
              label: Text('Select location'),
              onPressed: ()=>widget.userLocationInput(),
            ),
            FlatButton.icon(
              icon: Icon(Icons.map),
              label: Text('Select location from Map'),
              onPressed: (){},
            ),
          ],
        )
      ],
    );
  }
}

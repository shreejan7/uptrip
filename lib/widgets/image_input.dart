import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:path/path.dart' as path;
// import 'package:path_provider/path_provider.dart' as syspaths;

class ImageInput extends StatefulWidget {
  final Function storeImage;
  ImageInput(this.storeImage);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _storedImage;

  Future<void> _takePicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      _storedImage = imageFile;
    });
   widget.storeImage(imageFile);
  }
  Future<void> _uploadPicture() async {
    final imageFile = await ImagePicker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _storedImage = imageFile;
    });
   widget.storeImage(imageFile);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 150,
          height: 100,
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: _storedImage != null
              ? Image.file(
                  _storedImage,
                  fit: BoxFit.cover,
                  width: double.infinity,
                )
              : Text(
                  'No Image Taken',
                  textAlign: TextAlign.center,
                ),
          alignment: Alignment.center,
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            children: <Widget>[
              FlatButton.icon(
                icon: Icon(Icons.camera),
                label: Text('Take Picture'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _takePicture,
              ),
              FlatButton.icon(
                icon: Icon(Icons.file_upload),
                label: Text('Take Picture'),
                textColor: Theme.of(context).primaryColor,
                onPressed: _uploadPicture,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

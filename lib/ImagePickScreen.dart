import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testprojectdb/Uploader.dart';

import 'dart:ui';
import 'dart:io';

import 'dart:convert';

class ImagePickScreen extends StatefulWidget {

  @override
  _ImagePickScreenState createState() => _ImagePickScreenState();

}

class _ImagePickScreenState extends State<ImagePickScreen> {
  Uploader uploader = Uploader();
  File _image;
  List<int>  bytes;
  String base64Image;
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    bytes = image.readAsBytesSync();
    this.setState(() {
      _image = image;
      base64Image = base64Encode(bytes);
    });

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select image from gallery'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image selected.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Pick Image',
        child: Icon(Icons.add_photo_alternate),
      ),
      bottomNavigationBar: Material
        (
        child: RaisedButton(

          child:
          Text('Upload', style: TextStyle(fontSize: 20)),
          color: Color(0xff1B5E20),
          onPressed: () => {if (_image != null){ uploader.startUpload(_image,context)}},
          // Navigate to second route when tapped.
          // Navigator.pushNamed(context, '/second');

        ),

      ),

    );
  }
}

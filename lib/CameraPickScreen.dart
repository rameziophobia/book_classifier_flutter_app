import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:testprojectdb/Uploader.dart';

import 'dart:ui';
import 'dart:io';

import 'dart:convert';


class CameraPickScreen extends StatefulWidget {



  @override
  _CameraPickScreenState createState() => _CameraPickScreenState();

}

class _CameraPickScreenState extends State<CameraPickScreen> {
  Uploader uploader = Uploader();
  File _image;
  List<int>  bytes;
  String base64Image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture image'),
      ),
      body: Center(
        child: _image == null
            ? Text('No image captured.')
            : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        tooltip: 'Capture Image',
        child: Icon(Icons.add_a_photo),
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

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:ui';
import 'dart:io';


class ImagePickScreen extends StatefulWidget {

  @override
  _ImagePickScreenState createState() => _ImagePickScreenState();

}

class _ImagePickScreenState extends State<ImagePickScreen> {
  File _image;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

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
          onPressed: (


              ) {
            // Navigate to second route when tapped.
            // Navigator.pushNamed(context, '/second');
          },
        ),

      ),

    );
  }
}

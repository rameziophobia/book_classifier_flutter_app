import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageBanner extends StatelessWidget {
  Image _image;

  ImageBanner(path){
    _image = Image.asset(path, fit: BoxFit.contain);
  }
  
  ImageBanner.fromFile(File file){
    _image = Image.file(file, fit: BoxFit.contain);  
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: 200.0),
        decoration: BoxDecoration(color: Colors.grey),
        child: _image);
  }
}

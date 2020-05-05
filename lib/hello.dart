import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
//import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';

import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spine_classifier/ImageBanner.dart';
import 'package:flutter_spine_classifier/text_section.dart';
//import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UploadImageDemo extends StatefulWidget {
  // UploadImageDemo() : super();
  final String title = "Upload Image Demo";

  @override
  UploadImageDemoState createState() => UploadImageDemoState();
}

class UploadImageDemoState extends State<UploadImageDemo> {
  static final String uploadEndPoint = 'http://ramezio.pythonanywhere.com/';
  File _imageFile;
  String status = '';
  String base64Image;
  String errorMessage = 'Error Uploading Image';
  ImageBanner _mainBanner = ImageBanner('assets/images/shelf0.jpg');

  List<int>  bytes;

  _openGallery(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    bytes = image.readAsBytesSync();
    this.setState(() {
      _imageFile = image;
      _mainBanner = ImageBanner.fromFile(image);
      base64Image = base64Encode(bytes);
    });
    Navigator.of(context).pop();
  }

  _openCamera(context) async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    bytes = image.readAsBytesSync();
    this.setState(() {
      _imageFile = image;
      _mainBanner = ImageBanner.fromFile(image);
      base64Image = base64Encode(bytes);
    });
    Navigator.of(context).pop();
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: SingleChildScrollView(
                  child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallery"),
                onTap: () {
                  _openGallery(context);
                },
              ),
              GestureDetector(
                  child: Text("Camera"),
                  onTap: () {
                    _openCamera(context);
                  })
            ],
          )));
        });
  }

  int _counter = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Spine App'),
        ),
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
              _mainBanner,
              ImageBanner('assets/images/shelf1.jpg'),
              OutlineButton(
                onPressed: () => _showChoiceDialog(context),
                child: Text('Choose Image'),
              ),
              OutlineButton(
                onPressed: () => startUpload(),
                child: Text('Upload Image'),
              ),
              Text(status),
              TextSection(Colors.red),
              TextSection(Colors.blue),
              TextSection(Colors.yellow),
              Container(
                decoration: BoxDecoration(color: Colors.red),
                child: Text('data', textAlign: TextAlign.center),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.blue),
                child: Text('data'),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.green),
                child: Text('data$_counter'),
              )
            ])));
  }

  startUpload() {
    setStatus('Uploading Image...');
    if (null == _imageFile) {
      setStatus(errorMessage);
      return;
    }
    String fileName = _imageFile.path.split('/').last;
    upload(fileName);
  }

  setStatus(String message) {
    setState(() {
      status = message;
    });
  }

  upload(String fileName) async {

    var dio = new Dio();
    dio.options.baseUrl = uploadEndPoint;
    dio.options.connectTimeout = 50000; //50s
    dio.options.sendTimeout = 50000; //50s
    dio.options.receiveTimeout = 50000;
//    dio.options.headers = <Header Json>;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromBytes(bytes, filename: 'ya rab')
    });
//    formData.fields.add("user_id");
    var response = await dio.post("",
    data: formData,
    options: Options(
    method: 'POST',
    responseType: ResponseType.json // or ResponseType.JSON
    ));

      var res = Map<String, dynamic>.from(response.data);
      setStatus(response.statusCode == 200 ? res['title'] : errorMessage);
//    }).catchError((error) {
////      setStatus('error');
//    });
  }
}

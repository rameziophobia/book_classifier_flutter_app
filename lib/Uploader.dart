import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Book.dart';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
//import 'package:http_parser/http_parser.dart';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:io';
import 'database_helper.dart';

class Uploader {
  DatabaseHelper helper = DatabaseHelper();
  static final String uploadEndPoint = 'https://book-spine.herokuapp.com/shelf/';
  static Uploader _uploader; // Singleton DatabaseHelper
  String status = '';
  String errorMessage = 'Error Uploading Image';

  //File _imageFile;
  List<int> bytes;

//  Uploader(this._imageFile);


  Uploader._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory Uploader() {
    if (_uploader == null) {
      _uploader = Uploader
          ._createInstance(); // This is executed only once, singleton object
    }
    return _uploader;
  }

  void _showAlertDialog(String title, String message,BuildContext context) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

  startUpload(File _imageFile,BuildContext context) {
   // _showSnackBar(context, ' Uploading');
    _showAlertDialog('Status', 'Uploading Image...',  context);

    bytes = _imageFile.readAsBytesSync();
    setStatus('Uploading Image...');
    if (null == _imageFile) {
      setStatus(errorMessage);
      return;
    }
    String fileName = _imageFile.path
        .split('/')
        .last;
    upload(fileName, context);
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  setStatus(String message) {
    status = message;
  }


  upload(String fileName,BuildContext context) async {
    helper.deleteAllTemp();
    var dio = new Dio();
    dio.options.baseUrl = uploadEndPoint;
    dio.options.connectTimeout = 100000; //100s
    dio.options.sendTimeout = 100000; //100s
    dio.options.receiveTimeout = 50000;
//    dio.options.headers = <Header Json>;

    var response2 = await dio.get(uploadEndPoint).then((result) {
      result.data.forEach((element) {
        if(element['found']) {
          var book = Book(element['title'],
              element['average_rating'],
              element['url'],
              element['author'],
              '',
              element['summary']
          );
          helper.insertTodo(book, 'book_temp_table');
        }
      });

    }).catchError((onError) {
      print("error");
    });
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(bytes, filename: 'ya rab')
    });
//    formData.fields.add("user_id");
    var response = await dio.post("",
        data: formData,
        options: Options(
            method: 'POST',
            responseType: ResponseType.json // or ResponseType.JSON
        )).catchError((onError) {

    });
    Navigator.pushNamed(context, '/results');



    if (response != null) {
      var res = Map<String, dynamic>.from(response.data);



      setStatus(response.statusCode == 200 ? res['title'] : errorMessage);



    } else {
      setStatus('error: null response');
//      _showSnackBar(context, ' null response');
    }
  }
}


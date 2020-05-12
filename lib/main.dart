import 'package:flutter/material.dart';
import 'todo_list.dart';
import 'package:testprojectdb/ImagePickScreen.dart';
import 'package:testprojectdb/CameraPickScreen.dart';

import 'package:testprojectdb/Books.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => TodoList(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/image_pick': (context) => ImagePickScreen(),
          '/camera_pick': (context) => CameraPickScreen(),
         // '/results': (context) => ResultView(),

        });

  }
}

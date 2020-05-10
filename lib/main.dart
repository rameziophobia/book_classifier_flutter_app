
import 'dart:ui';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';


void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {

  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => FirstScreen(),
          // When navigating to the "/second" route, build the SecondScreen widget.
          '/second': (context) => SecondScreen(),
          '/image_pick': (context) => ImagePickScreen(),
          '/camera_pick': (context) => CameraPickScreen(),
        });

  }

// #enddocregion build
}
// #enddocregion MyApp

// #docregion RWS-var
class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10)); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(WordPair pair) {
    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
    );
  }
  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cvc2020'),
      ),
      body: _buildSuggestions(),
    );
  }
// #enddocregion RWS-build
// #docregion RWS-var
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  RandomWordsState createState() => new RandomWordsState();
}
class FirstScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('cvc'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('test'),
          onPressed: () {
            // Navigate to second route when tapped.
           // Navigator.pushNamed(context, '/second');
          },
        ),


      ),



      floatingActionButton: SpeedDial(
        // both default to 16
        marginRight: 20,
        marginBottom: 22,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 24.0),
        // this is ignored if animatedIcon is non null
        // child: Icon(Icons.add),
        visible: true,
        // If true user is forced to close dial manually
        // by tapping main button and overlay is not rendered.
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        tooltip: 'Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        elevation: 8.0,
        shape: CircleBorder(),
        children: [
          SpeedDialChild(
              child: Icon(Icons.camera),
              backgroundColor: Colors.green,
              label: 'Camera',
              labelStyle: TextStyle(fontSize: 19.0),
              onTap: () => Navigator.pushNamed(context, '/camera_pick')
          ),
          SpeedDialChild(
            child: Icon(Icons.photo_library),
            backgroundColor: Colors.red,
            label: 'Gallery',
            labelStyle: TextStyle(fontSize: 19.0),
            onTap: () => Navigator.pushNamed(context, '/image_pick') // open gallery
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class SecondScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Route"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}




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



class CameraPickScreen extends StatefulWidget {

  @override
  _CameraPickScreenState createState() => _CameraPickScreenState();

}

class _CameraPickScreenState extends State<CameraPickScreen> {
  File _image;

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
/*
class Book {

  final int score;
  final String name;
  final String Authname;
  final String Summary;

  Book({this.score, this.name, this.Authname, this.Summary});

  Map<String, dynamic> toMap() {
    return {
      'Name': name,
      'Score': score,
      'Author': Authname,
      'Summary': Summary,
    };
  }
}

  Future<void> insertBook(Book book) async {
    // Get a reference to the database.
    final Database db = await database;

    // Insert the Dog into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same dog is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'books',
      book.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

}
// Create a Dog and add it to the dogs table.
  final fido =  Book(
    name: 'how to train your cat',
    score: 8,
    Authname: 'Pierre Adel',
    Summary: 'this book is very good.'
  );

await insertBook(fido);


















// Open the database and store the reference.
final Future<Database> database = openDatabase(
  // Set the path to the database. Note: Using the `join` function from the
  // `path` package is best practice to ensure the path is correctly
  // constructed for each platform.
    join(await getDatabasesPath(), 'book_database.db'),
);

final Future<Database> database = openDatabase(
  // Set the path to the database.
    join(await getDatabasesPath(), 'book_database.db'),
// When the database is first created, create a table to store dogs.
    onCreate: (db, version) {
// Run the CREATE TABLE statement on the database.
return db.execute(
"CREATE TABLE dogs(Name TEXT PRIMARY KEY, Score INTEGER, Author TEXT, Summary TEXT)",
);
},
// Set the version. This executes the onCreate function and provides a
// path to perform database upgrades and downgrades.
version: 1,
);
*/

import 'dart:ui';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

import 'dart:async';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'ImagePickScreen.dart';
import 'CameraPickScreen.dart';



import 'Book.dart';
import 'database.dart';
import 'book_detail.dart';








void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {

  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          // When navigating to the "/" route, build the FirstScreen widget.
          '/': (context) => BookListScreen(),
          // When navigating to the "/second" route, build the SecondScreen widget.
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

class BookListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MainScreen();
  }
}

class MainScreen extends State<BookListScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Book> bookList;
  int count = 0;


  @override
  Widget build(BuildContext context) {
    if (bookList == null) {
      bookList = List<Book>();

      updateListView();

    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Main'),
      ),
      body: getBookListView(),


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
              onTap: () =>
                  Navigator.pushNamed(context, '/image_pick') // open gallery
          ),
          SpeedDialChild(
              child: Icon(Icons.book),
              backgroundColor: Colors.black,
              label: 'Book(for debug)',
              labelStyle: TextStyle(fontSize: 19.0),
              onTap: () =>
                  navigateToDetail(context,Book('', '', '','',''), 'Add Book')
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }


  ListView getBookListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.amber,
              child: Text(getFirstLetter(this.bookList[position].name),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.bookList[position].name,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.bookList[position].authName),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete, color: Colors.red,),
                  onTap: () {
                    _delete(context, bookList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              navigateToDetail(context,this.bookList[position], 'Edit Book');
            },
          ),
        );
      },
    );
  }


  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Book book) async {
    int result = await databaseHelper.deleteBook(book.name);
    if (result != 0) {
      _showSnackBar(context, 'Book Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(BuildContext context, Book book, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BookDetailScreen(book, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Book>> bookListFuture = databaseHelper.getBookList();
      bookListFuture.then((bookList) {
        setState(() {
          this.bookList = bookList;
          this.count = bookList.length;
        });
      });
    });
  }


}

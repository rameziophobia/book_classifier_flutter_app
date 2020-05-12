import 'dart:async';
import 'package:flutter/material.dart';
import 'Book.dart';
import 'database_helper.dart';
import 'book_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class TodoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TodoListState();
  }
}

class TodoListState extends State<TodoList> {
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
        title: Text('Books'),
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
                  navigateToDetail(Book('', '', '','',''), 'Add Book')
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );


  }
  /*

*/

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
              child: Text(getFirstLetter(this.bookList[position].title),
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            title: Text(this.bookList[position].title,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(this.bookList[position].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(Icons.delete,color: Colors.red,),
                  onTap: () {
                    _delete(context, bookList[position]);
                  },
                ),
              ],
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              viewDetail(this.bookList[position], 'view Todo');
            },
          ),
        );
      },
    );
  }

  getFirstLetter(String title) {
    return title.substring(0, 2);
  }

  void _delete(BuildContext context, Book todo) async {
    int result = await databaseHelper.deleteBook(todo.id,'book_table');
    if (result != 0) {
      _showSnackBar(context, 'Book Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigateToDetail(Book todo, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetail(todo, title);
    }));
    updateListView();
  }
    void viewDetail(Book todo, String title) async {
      bool result =
      await Navigator.push(context, MaterialPageRoute(builder: (context) {
        return TodoDetailView(todo, title,false);
      }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Book>> todoListFuture = databaseHelper.getBookList('book_table');
      todoListFuture.then((todoList) {
        setState(() {
          this.bookList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }


}
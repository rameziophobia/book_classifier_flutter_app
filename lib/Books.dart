/*import 'dart:async';
import 'package:flutter/material.dart';
import 'Todo.dart';
import 'database_helper.dart';
import 'todo_detail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';


class ResultView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ResultViewState();
  }
}
class ResultViewState extends State<ResultView> {
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
      bottomNavigationBar: Material
    (
    child: RaisedButton(

    child:
    Text('Return to home screen', style: TextStyle(fontSize: 20)),
    color: Color(0xFF1DE9B6),
    onPressed: () => Navigator.pushNamed(context, '/')
    // Navigate to second route when tapped.
    // Navigator.pushNamed(context, '/second');

    ),

    );

  }

  ListView getBookListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white70,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlue,
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
                  child: Icon( alreadySaved ? Icons.favorite : Icons.favorite_border,
                    color: alreadySaved ? Colors.red : null,),
                  onTap: () {
                setState(() {
                if (alreadySaved) {
                _saved.remove(pair);
                } else {
                _saved.add(pair);
                }
                });

        // _delete(context, bookList[position]);
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


  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void viewDetail(Book todo, String title) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return TodoDetailView(todo, title);
    }));

    if (result == true) {
      updateListView();
    }
  }

  void updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Book>> todoListFuture = databaseHelper.getBookList();
      todoListFuture.then((todoList) {
        setState(() {
          this.bookList = todoList;
          this.count = todoList.length;
        });
      });
    });
  }


}*/
import 'dart:async';
import 'package:flutter/material.dart';
import 'Todo.dart';
import 'database_helper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class TodoDetail extends StatefulWidget {

  final String appBarTitle;
  final Book todo;


  TodoDetail(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return TodoDetailState(this.todo, this.appBarTitle);
  }
}

class TodoDetailState extends State<TodoDetail> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Book todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController urlController = TextEditingController();
  TextEditingController authNameController = TextEditingController();
  TextEditingController scoreController = TextEditingController();
  TextEditingController genreController = TextEditingController();

  TodoDetailState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateTitle();
                    },
                    decoration: InputDecoration(
                        labelText: 'Title',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: genreController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Title Text Field');
                      updateGenre();
                    },
                    decoration: InputDecoration(
                        labelText: 'Genre',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: scoreController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in score Text Field');
                       updateScore();
                    },
                    decoration: InputDecoration(
                        labelText: 'score',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: authNameController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in authName Text Field');
                       updateAuthName();
                    },
                    decoration: InputDecoration(
                        labelText: 'authName',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: urlController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in url Text Field');
                       updateUrl();
                    },
                    decoration: InputDecoration(
                        labelText: 'url',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller:descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in summary Text Field');
                       updateDescription();
                    },
                    decoration: InputDecoration(
                        labelText: 'summary',
                        labelStyle: textStyle,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0)
                        )
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Save',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Save button clicked");
                              _save();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of todo object
  void updateTitle(){
    todo.title = titleController.text;
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }
  void updateScore() {
    todo.score = scoreController.text;
  }
  void updateUrl() {
    todo.url = urlController.text;
  }
  void updateAuthName() {
    todo.authName = authNameController.text;
  }
  void updateGenre() {
    todo.genre = genreController.text;
  }

  // Save data to database
  void _save() async {

    moveToLastScreen();

    //todo.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (todo.id != null) {  // Case 1: Update operation
      result = await helper.updateTodo(todo,'book_table');
    } else { // Case 2: Insert Operation
      result = await helper.insertTodo(todo,'book_table');
    }

    if (result != 0) {  // Success
      _showAlertDialog('Status', 'Book Saved Successfully');
    } else {  // Failure
      _showAlertDialog('Status', 'Problem Saving Book');
    }

  }


  void _delete() async {

    moveToLastScreen();

    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    int result = await helper.deleteBook(todo.id,'book_table');
    if (result != 0) {
      _showAlertDialog('Status', 'Todo Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Todo');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }

}











class TodoDetailView extends StatefulWidget {

  final String appBarTitle;
  final Book todo;



  TodoDetailView(this.todo, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {

    return TodoDetailViewState(this.todo, this.appBarTitle);
  }
}

class TodoDetailViewState extends State<TodoDetailView> {

  DatabaseHelper helper = DatabaseHelper();

  String appBarTitle;
  Book todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();


  TodoDetailViewState(this.todo, this.appBarTitle);

  @override
  Widget build(BuildContext context) {

    TextStyle textStyle = Theme.of(context).textTheme.title;

   // titleController.text = todo.title;
    //descriptionController.text = todo.description;

    return WillPopScope(

        onWillPop: () {
          moveToLastScreen();
        },

        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(icon: Icon(
                Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }
            ),
          ),

          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[

                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text.rich(
                      TextSpan(
                        // text: todo.title, // default text style
                        children: <TextSpan>[
                          TextSpan(text: 'Title: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: todo.title , style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                ),

                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text.rich(
                      TextSpan(
                        //text: 'Hello', // default text style
                        children: <TextSpan>[
                          TextSpan(text: 'Author: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: todo.authname, style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                ),
                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text.rich(
                      TextSpan(
                        //text: 'Hello', // default text style
                        children: <TextSpan>[
                          TextSpan(text: 'Genre: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: todo.genre, style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                ),

                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text.rich(
                      TextSpan(
                        //text: 'Hello', // default text style
                        children: <TextSpan>[
                          TextSpan(text: 'Score: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: todo.score, style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                ),

                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text.rich(
                      TextSpan(
                        //text: 'Hello', // default text style
                        children: <TextSpan>[
                          TextSpan(text: 'URL: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: todo.url, style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                ),

                Padding(
                    padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                    child: Text.rich(
                      TextSpan(
                        //text: 'Hello', // default text style
                        children: <TextSpan>[
                          TextSpan(text: 'Summary: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: todo.description, style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    )
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Open URL',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("open url button clicked");
                              //_save();
                              _launchURL(todo.url);
                              //moveToLastScreen();
                            });
                          },
                        ),
                      ),

                      Container(width: 5.0,),

                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            'Delete',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              debugPrint("Delete button clicked");
                              _delete();
                            });
                          },
                        ),
                      ),

                    ],
                  ),
                ),


              ],
            ),
          ),

        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of todo object
  void updateTitle(){
    todo.title = titleController.text;
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }



  void _delete() async {

    moveToLastScreen();

    if (todo.id == null) {
      _showAlertDialog('Status', 'No Todo was deleted');
      return;
    }

    int result = await helper.deleteBook(todo.id,'book_table');
    if (result != 0) {
      _showAlertDialog('Status', 'Todo Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Todo');
    }
  }

  void _showAlertDialog(String title, String message) {

    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(
        context: context,
        builder: (_) => alertDialog
    );
  }


  _launchURL(String todourl) async {
    String url = todourl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';

    }
  }


}
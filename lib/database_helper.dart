import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'Todo.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String bookTable = 'book_table';
  String bookTempTable = 'book_temp_table';

  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colscore = 'score';
  String colurl = 'url';
  String colauthname = 'auth';
  String colgenre = 'genre';

  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'todos.db';

    // Open/create the database at a given path
    var todosDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return todosDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $bookTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colscore TEXT,$colauthname TEXT , $colurl TEXT, $colgenre TEXT)');
    await db.execute('CREATE TABLE $bookTempTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, $colDescription TEXT, $colscore TEXT,$colauthname TEXT , $colurl TEXT, $colgenre TEXT)');


  }

  // Fetch Operation: Get all todo objects from database
  Future<List<Map<String, dynamic>>> getTodoMapList(String table) async {
    Database db = await this.database;
    var result;
//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');

     result = await db.query(table, orderBy: '$colTitle ASC');

    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> insertTodo(Book todo,String table) async {
    Database db = await this.database;
    var result = await db.insert(table, todo.toMap());
    return result;
  }

  // Update Operation: Update a todo object and save it to database
  Future<int> updateTodo(Book todo,String table) async {
    var db = await this.database;
    var result = await db.update(table, todo.toMap(), where: '$colId = ?', whereArgs: [todo.id]);
    return result;
  }


  // Delete Operation: Delete a todo object from database
  Future<int> deleteBook(int id,String table) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $table WHERE $colId = $id');
    return result;
  }

  // Get number of todo objects in database
  Future<int> getCount(String table) async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]
  Future<List<Book>> getBookList(String table) async {

    var todoMapList = await getTodoMapList(table); // Get 'Map List' from database
    int count = todoMapList.length;         // Count the number of map entries in db table

    List<Book> todoList = List<Book>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      todoList.add(Book.fromMapObject(todoMapList[i]));
    }

    return todoList;
  }

}
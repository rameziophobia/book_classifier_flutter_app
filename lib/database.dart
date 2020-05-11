
import 'dart:async';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'Book.dart';

import 'package:path_provider/path_provider.dart';



class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String bookTable = 'book_table';
  String colname = 'name';
  String colscore = 'score';
  String colauthName = 'authName';
  String colurl = 'url';
  String colsummary = 'summary';

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
    String path = directory.path + 'book_databse.db';

    // Open/create the database at a given path
    var booksDatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return booksDatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $bookTable($colname TEXT PRIMARY KEY , $colscore TEXT, '
        '$colauthName TEXT, $colurl TEXT,$colsummary TEXT)');
  }

  // Fetch Operation: Get all todo objects from database
  Future<List<Map<String, dynamic>>> getBookMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $todoTable order by $colTitle ASC');
    var result = await db.query(bookTable, orderBy: '$colname ASC');
    return result;
  }

  // Insert Operation: Insert a todo object to database
  Future<int> insertBook(Book book) async {
    Database db = await this.database;
    var result = await db.insert(bookTable, book.toMap());
    return result;
  }

  // Update Operation: Update a todo object and save it to database
  Future<int> updateBook(Book book) async {
    var db = await this.database;
    var result = await db.update(bookTable, book.toMap(), where: '$colname = ?', whereArgs: [book.name]);
    return result;
  }


  // Delete Operation: Delete a todo object from database
  Future<int> deleteBook(String name) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $bookTable WHERE $colname = $name');
    return result;
  }

  // Get number of todo objects in database
  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $bookTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'todo List' [ List<Todo> ]
  Future<List<Book>> getBookList() async {

    var bookMapList = await getBookMapList(); // Get 'Map List' from database
    int count = bookMapList.length;         // Count the number of map entries in db table

    List<Book> bookList = List<Book>();
    // For loop to create a 'todo List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      bookList.add(Book.fromMapObject(bookMapList[i]));
    }

    return bookList;
  }

}
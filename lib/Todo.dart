
class Book {

  int _id;
  String _title;
  String _description;
  String _score;
  String _url;
  String _authname;
  String _genre;



  Book(this._title, this._score,this._url,this._authname,this._genre, [this._description] );

  Book.withId(this._id,this._title, this._score,this._url,this._authname,this._genre, [this._description] );

  int get id => _id;

  String get title => _title;

  String get description => _description;

  String get score => _score;
  String get url => _url;
  String get authname => _authname;
  String get genre => _genre;



  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set description(String newDescription) {
    if (newDescription.length <= 255) {
      this._description = newDescription;
    }
  }

  set score(String newDate) {
    this._score = newDate;
  }
  set url(String newUrl) {
    this._url = newUrl;
  }
  set authName(String newauthName) {
    this._authname = newauthName;
  }
  set genre(String newGenre) {
    this._genre = newGenre;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['score'] = _score;
    map['url'] = _url;
    map['auth'] = _authname;
    map['genre'] = _genre;

    return map;
  }

  // Extract a Note object from a Map object
  Book.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._score = map['score'];
    this._url = map['url'];
    this._authname = map['auth'];
    this._genre = map['genre'];


  }
}









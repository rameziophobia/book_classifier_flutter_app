
/*
class Book {





  Book({ this._name,this._score, this._authName,this._url, this._summary});

  Map<String, dynamic> toMap() {
    return {
      'name': _name,
      'score': _score,
      'author': _authName,
      'url': _url,
      'summary': _summary,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Book{name: $_name, score: $_score, author: $_authName, url: $_url, summary: $_summary }';
  }


  Book.fromMapObject(Map<String, dynamic> map) {
    this._name = map['name'];
    this._score = map['score'];
    this._authName = map['authName'];
    this._url = map['url'];
    this._summary = map['summary'];

  }
}*/

class Book {

  String _name;
  String _score;
  String _authName;
  String _url;
  String _summary;


  Book(this._name, this._score, this._authName,this._url,this._summary );

  String get name  => _name;

  String get score => _score;

  String get authName => _authName;

  String get url => _url;
  String get summary => _summary;


  set name(String newTitle) {
    if (newTitle.length <= 255) {
      this._name = newTitle;
    }
  }
  set summary(String newDescription) {
    if (newDescription.length <= 255) {
      this._summary = newDescription;
    }
  }

  set score(String s) {
    this._score = s;
  }

  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (name != null) {
      map['name'] = _name;
    }
    map['score'] = _score;
    map['authName'] = _authName;
    map['url'] = _url;
    map['summary'] = _summary;

    return map;
  }



  Book.fromMapObject(Map<String, dynamic> map) {
    this._name = map['name'];
    this._score = map['score'];
    this._authName = map['authName'];
    this._url = map['url'];
    this._summary = map['summary'];

  }
}


class LendenDB{
  int _id;
  String _record;
  String _description;
  String _date;
  int _priority;

  LendenDB(this._record, this._date, this._priority, [this._description]);

  LendenDB.withId(this._id,this._record, this._date, this._priority, [this._description]);

  int get id => _id;

  String get record => _record;

  String get description => _description;

  String get date => _date;

  int get priority => _priority;

  set record(String newRecord){
    if(newRecord.length <= 100){
      this._record = newRecord;
    }
  }

  set description(String newDescription){
    if(newDescription.length <= 300){
      this._description= newDescription;
    }
  }

  set priority(int newPriority){
    if(newPriority >= 1 && newPriority <=2){
      this._priority = newPriority;
    }
  }


  set date(String newDate){
    this._date= newDate;
    }

    //convert a LendenDB object into map object
    Map<String, dynamic> toMap(){

    var map = Map<String, dynamic>();

    if(id != null) {
      map['id'] = _id;
    }
    map['record'] = _record;
    map['description'] = _description;
    map['priority'] = _priority;
    map['date'] = _date;

    return map;
  }

//extract a LendenDB object from map object
   LendenDB.fromMapObject(Map<String, dynamic>map){
    this._id = map['id'];
    this._record = map['record'];
    this._description = map['description'];
    this._priority = map['priority'];
    this._date = map['date'];
   }
}
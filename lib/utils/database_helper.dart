import 'package:lenden/models/lendenDB.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';



class DatabaseHelper{

  static DatabaseHelper _databaseHelper;
  static Database _database;

  String lendenTable = 'lenden_table';
  String colId = 'id';
  String colRecord = 'record';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';

  DatabaseHelper._createInstance();

  factory DatabaseHelper(){

    if(_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }

  Future<Database> get database async{

    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory directory =await getApplicationDocumentsDirectory();
    String path = directory.path + 'lenden.db';
    
    var lendenDatabase = await openDatabase(path, version: 1, onCreate: _createDB);
    return lendenDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $lendenTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colRecord TEXT,'
        '$colDescription TEXT, $colPriority INTEGER, $colDate TEXT)');
  }

  //fetch operation
  Future<List<Map<String, dynamic>>> getLenDenMapList() async{
    Database db = await this.database;

//    var result = await db.rawQuery('SELECT * FROM $lendenTable order by $colPriority ASC');
      var result = await db.query(lendenTable, orderBy: '$colPriority ASC');
      return result;
  }

  //Insert Operation
  Future<int> insertRecord(LendenDB lendendb)async{
    Database db = await this.database;
    var result = await db.insert(lendenTable,lendendb.toMap());
    return result;
  }

  //update operation
  Future<int> updateRecord(LendenDB lendendb)async{
    var db = await this.database;
    var result = await db.update(lendenTable, lendendb.toMap(), where:'$colId = ?',whereArgs:[lendendb.id]);
    return result;
  }

  //delete operation
  Future<int> deleteRecord(int id)async{
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $lendenTable WHERE $colId = $id');
    return result;
  }

  //record count
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) from $lendenTable');
    int result = Sqflite.firstIntValue(x);
    return result;
}
  Future<List<LendenDB>> getLendenList() async{

    var noteMapList =  await getLenDenMapList();
    int count = noteMapList.length;

    List<LendenDB> noteList = List<LendenDB>();

    for(int i=0; i<count; i++){
      noteList.add(LendenDB.fromMapObject(noteMapList[i]));

    }
    return noteList;
  }
}
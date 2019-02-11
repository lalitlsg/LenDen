import 'package:flutter/material.dart';
import 'package:lenden/models/lendenDB.dart';
import 'package:lenden/screens/detail.dart';
import 'package:lenden/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'package:firebase_admob/firebase_admob.dart';



class LenDen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {

    return LenDenState();
  }
}

class LenDenState extends State<LenDen>{
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<LendenDB> lendenList;
  int count = 0;


  @override
  Widget build(BuildContext context) {

    if(lendenList == null){
      lendenList = List<LendenDB>();
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('LenDen'),
      ),
      body: getLenDenView(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          navigateToDetail(LendenDB('', '', 2),'Add Record');
        },
        tooltip: 'Add Record',
        child: Icon(Icons.add),
      ),
    );
  }

  ListView getLenDenView(){

    TextStyle titleStyle = Theme.of(context).textTheme.subhead;

    return ListView.builder(
        itemCount: count,
        itemBuilder: (BuildContext context, int position){
          return Card(
            color: Colors.white70,
            elevation: 2.0,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: getPriorityColor(this.lendenList[position].priority),
                child:  Text(this.lendenList[position].record[0],
                style: TextStyle(
                  color: Colors.white
                ),)
              ),
              title: Text(this.lendenList[position].record,style: titleStyle,),
              subtitle: Text(this.lendenList[position].date),
              trailing:GestureDetector(
                child:Icon(Icons.delete,color: Colors.grey,),
                onTap: (){
                  _delete(context, lendenList[position]);
                },
              ),
              onTap: (){
                 navigateToDetail(this.lendenList[position],'Edit Record');
              },
            ),
          );
        }
    );
  }

  //priority color
  Color getPriorityColor(int priority){
    switch(priority)  {
      case 1:
        return Colors.red;
        break;
      case 2:
        return Colors.green;
        break;
      default:
        return Colors.green;
    }
  }



  void _delete(BuildContext context,LendenDB lenden) async{
    int result = await databaseHelper.deleteRecord(lenden.id);
    if(result != 0){
      _showSnackBar(context,'Record Deleted Successfully');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context,String message){
    final snackbar = SnackBar(content: Text(message));
    Scaffold.of(context).showSnackBar(snackbar);
  }
  //priority icon

  void navigateToDetail(LendenDB lendendb, String title)async{
  bool result = await Navigator.push(context, MaterialPageRoute(builder: (context){
      return Detail(lendendb,title);
    }));
  if(result == true){
    updateListView();
  }
  }

  void updateListView(){
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database){

      Future<List<LendenDB>> noteListFuture = databaseHelper.getLendenList();
      noteListFuture.then((lendenList){
        setState(() {
          this.lendenList = lendenList;
          this.count = lendenList.length;
        });
      });
    });
  }
}

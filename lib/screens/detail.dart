import 'package:flutter/material.dart';
import 'package:lenden/models/lendenDB.dart';
import 'package:lenden/utils/database_helper.dart';
import 'package:intl/intl.dart';

class Detail extends StatefulWidget {
  final String appBarTitle;
  final LendenDB lendendb;
  Detail(this.lendendb, this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return DetailState(this.lendendb, this.appBarTitle);
  }
}

class DetailState extends State<Detail> {
  var _formKey = GlobalKey<FormState>();

  String appBarTitle;
  LendenDB lendendb;
  DetailState(this.lendendb, this.appBarTitle);

  static var _priorities = ['Greater than 100', 'Less than 100'];

  DatabaseHelper helper = DatabaseHelper();

  TextEditingController recordController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  FocusNode _focusNode1 = FocusNode();
  FocusNode _focusNode2 = FocusNode();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    recordController.text = lendendb.record;
    descriptionController.text = lendendb.description;

    recordController.addListener(onChanged);
    _focusNode1.addListener(onChanged);

    descriptionController.addListener(onDescriptionChanged);
    _focusNode2.addListener(onDescriptionChanged);

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Form(
            key: _formKey,
            child: Padding(
                padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      title: DropdownButton(
                          items: _priorities.map((String dropDownStringItem) {
                            return DropdownMenuItem<String>(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          style: textStyle,
                          value: getPriorityAsString(lendendb.priority),
                          onChanged: (valueSelectedByUser) {
                            setState(() {
                              updatePriorityAsInt(valueSelectedByUser);
                            });
                          }),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        controller: recordController,
                        style: textStyle,
                        focusNode: _focusNode1,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please Enter Record';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Record',
                            hintText: 'eg.Sam to Jack = 70',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                      child: TextFormField(
                        controller: descriptionController,
                        style: textStyle,
                        focusNode: _focusNode2,
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Please Enter Description';
                          }
                        },
                        decoration: InputDecoration(
                            labelText: 'Description',
                            hintText: 'eg.Movie Ticket',
                            labelStyle: textStyle,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0))),
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
                                    if (_formKey.currentState.validate())
                                      _save();
                                  });
                                }),
                          ),
                          Container(
                            width: 5.0,
                          ),
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
                                    _delete();
                                  });
                                }),
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

//Convert int to string priority
  void updatePriorityAsInt(String value) {
    switch (value) {
      case 'Greater than 100':
        lendendb.priority = 1;
        break;
      case 'Less than 100':
        lendendb.priority = 2;
        break;
    }
  }

  //convert string priority to int priority

  String getPriorityAsString(int value) {
    String priority;
    switch (value) {
      case 1:
        priority = _priorities[0];
        break;
      case 2:
        priority = _priorities[1];
        break;
    }
    return priority;
  }

  void updateRecord() {
    lendendb.record = recordController.text;
  }

  void updateDescription() {
    lendendb.description = descriptionController.text;
  }

  void _save() async {
    moveToLastScreen();

    lendendb.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    if (lendendb.id != null) {
      result = await helper.updateRecord(lendendb);
    } else {
      result = await helper.insertRecord(lendendb);
    }

    if (result != 0) {
      _showAlertDialog('Status', 'Record Saved Successfully');
    } else {
      _showAlertDialog('Status', 'Problem Saving Record');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    moveToLastScreen();
    if (lendendb.id == null) {
      _showAlertDialog('Status', 'No Record was deleted');
      return;
    }

    int result = await helper.deleteRecord(lendendb.id);

    if (result != 0) {
      _showAlertDialog('Status', 'Record Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Record');
    }
  }

  void onChanged() {
    updateRecord();
  }

  void onDescriptionChanged() {
    updateDescription();
  }
}

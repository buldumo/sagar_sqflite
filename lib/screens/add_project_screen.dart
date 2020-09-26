import "package:flutter/material.dart";
import 'package:sagar_sqflite/model/task.dart';
import 'package:sagar_sqflite/scoped_model/todo_list_model.dart';
import 'package:scoped_model/scoped_model.dart';

class AddProjectScreen extends StatefulWidget {
  _AddProjectScreenState createState() => _AddProjectScreenState();
}

class _AddProjectScreenState extends State<AddProjectScreen> {
  String newTask;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      newTask = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'New Project',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            brightness: Brightness.light,
          ),
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Project will help you group related stuff',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (text) {
                    setState(
                      () {
                        newTask = text;
                      },
                    );
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Enter project name',
                      hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 36,
                      )),
                ),
                SizedBox(height: 26),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: Builder(builder: (BuildContext context) {
            return FloatingActionButton.extended(
              backgroundColor: Colors.teal,
              icon: Icon(Icons.save),
              label: Text("Create new project"),
              onPressed: () {
                if (newTask.isEmpty) {
                  final snackbar = SnackBar(
                    content: Text(
                        'You are writing invisible text. Please write something.'),
                    backgroundColor: Colors.black,
                  );
                  Scaffold.of(context).showSnackBar(snackbar);
                } else {
                  model.insertTask(
                    Task(
                      newTask,
                      color: Colors.purple.value,
                    ),
                  );
                  Navigator.pop(context);
                }
              },
            );
          }),
        );
      },
    );
  }
}

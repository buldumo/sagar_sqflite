import 'package:flutter/material.dart';
import 'package:sagar_sqflite/model/task.dart';
import 'package:sagar_sqflite/scoped_model/todo_list_model.dart';
import 'package:scoped_model/scoped_model.dart';

class EditTaskScreen extends StatefulWidget {
  final String projectName;
  final String projectId;

  const EditTaskScreen({Key key, this.projectName, this.projectId})
      : super(key: key);

  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String newProject;

  @override
  void initState() {
    super.initState();
    setState(() {
      newProject = widget.projectName;
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
              'Edit Project',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
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
                TextFormField(
                  initialValue: newProject,
                  onChanged: (value) {
                    setState(() {
                      newProject = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Project Name...',
                    hintStyle: TextStyle(color: Colors.black26),
                  ),
                  style: TextStyle(
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                      fontSize: 36),
                ),
                SizedBox(
                  height: 26,
                )
              ],
            ),
          ),
          floatingActionButton: Builder(builder: (BuildContext context) {
            return FloatingActionButton.extended(
              label: Text('Save changes'),
              icon: Icon(Icons.save),
              onPressed: () {
                if (newProject.isEmpty) {
                  final snackBar = SnackBar(
                    content: Text(
                        'You are writing invisible text, please write something.'),
                    backgroundColor: Colors.blue,
                  );
                  Scaffold.of(context).showSnackBar(snackBar);
                } else {
                  model.updateTask(Task(
                    newProject,
                    color: Colors.grey.value,
                    id: widget.projectId,
                  ));
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

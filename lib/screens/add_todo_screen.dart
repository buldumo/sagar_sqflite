import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sagar_sqflite/model/hero_id_model.dart';
import 'package:sagar_sqflite/model/todo.dart';
import 'package:sagar_sqflite/scoped_model/todo_list_model.dart';
import 'package:scoped_model/scoped_model.dart';

class AddTodoScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroIds;

  const AddTodoScreen({Key key, @required this.taskId, @required this.heroIds})
      : super(key: key);

  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  String newTodo;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      newTodo = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (context, child, model) {
        if (model.todos.isEmpty) {
          return Container(color: Colors.white);
        }
        var _task = model.todos.firstWhere(
            (element) => element.id == widget.taskId,
            orElse: () => null);
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Add Todo',
              style: TextStyle(color: Colors.black),
            ),
            centerTitle: true,
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
          ),
          body: Container(
            constraints: BoxConstraints.expand(),
            padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What are you planning to add?',
                  style: TextStyle(
                    color: Colors.black38,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      newTodo = value;
                    });
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Enter your todo',
                    hintStyle: TextStyle(
                      color: Colors.black26,
                    ),
                  ),
                  style: TextStyle(
                    color: Colors.black54,
                    fontWeight: FontWeight.w500,
                    fontSize: 36,
                  ),
                ),
                SizedBox(
                  height: 26,
                ),
                // Hero(
                //   child: Text(
                //     _task.name,
                //     style: TextStyle(
                //       color: Colors.black38,
                //       fontWeight: FontWeight.w600,
                //     ),
                //   ),
                //   tag: "not_using_right_now", //widget.heroIds.titleId,
                // ),
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Builder(builder: (BuildContext context) {
            return FloatingActionButton.extended(
              label: Text('Create todo'),
              backgroundColor: Colors.teal,
              icon: Icon(Icons.save),
              onPressed: () {
                if (newTodo.isEmpty) {
                  final snackbar = SnackBar(
                    content: Text(
                        'You are writing invisible text. Please write something.'),
                    backgroundColor: Colors.black,
                  );
                  Scaffold.of(context).showSnackBar(snackbar);
                } else {
                  print('I\'m in else block in floatingActionButton');
                  model.insertTodo(
                    Todo(
                      newTodo,
                      parent: _task.id,
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

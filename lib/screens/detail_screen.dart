import "package:flutter/material.dart";
import 'package:sagar_sqflite/model/hero_id_model.dart';
import 'package:sagar_sqflite/model/task.dart';
import 'package:sagar_sqflite/scoped_model/todo_list_model.dart';
import 'package:scoped_model/scoped_model.dart';

import 'add_todo_screen.dart';

class DetailScreen extends StatefulWidget {
  final String taskId;
  final HeroId heroId;

  const DetailScreen({Key key, @required this.taskId, this.heroId})
      : super(key: key);
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<Offset> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(begin: Offset(0, 0.1), end: Offset(0, 0))
        .animate(_controller);
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();
    return ScopedModelDescendant<TodoListModel>(
      builder: (context, child, model) {
        Task _task;
        try {
          _task =
              model.tasks.firstWhere((element) => element.id == widget.taskId);
        } catch (e) {
          return Container(
            color: Colors.white,
            child: Center(child: Text('You\'ve got error')),
          );
        }
        var _hero = widget.heroId;
        var _todos = model.todos
            .where((element) => element.parent == widget.taskId)
            .toList();

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text('Edit text'),
            elevation: 0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            actions: [
              IconButton(icon: Icon(Icons.edit), onPressed: () {}),
            ],
          ),
          body: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 36, vertical: 36),
                height: 160,
                child: Column(
                  children: [
                    Text(
                      '${model.getTotalTodoFrom(_task)} Task',
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.black54),
                    ),
                    Text(
                      _task.name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _todos.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == _todos.length) {
                      return SizedBox(
                        height: 56,
                      );
                    }
                    var todo = _todos[index];
                    return Container(
                      padding: EdgeInsets.only(left: 22, right: 22),
                      child: ListTile(
                        onTap: () => model.updateTodo(todo.copy(
                            isCompleted: todo.isCompleted == 1 ? 0 : 1)),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                        leading: Checkbox(
                            value: todo.isCompleted == 1 ? true : false,
                            onChanged: (value) => model.updateTodo(
                                todo.copy(isCompleted: value ? 1 : 0))),
                        trailing: IconButton(
                            icon: Icon(Icons.delete_outline),
                            onPressed: () => model.deleteTodo(todo)),
                        title: Text(
                          todo.name,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: todo.isCompleted == 1
                                ? Colors.grey
                                : Colors.black54,
                            decoration: todo.isCompleted == 1
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => AddTodoScreen(
                        taskId: widget.taskId,
                        heroIds: _hero,
                      )));
            },
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            tooltip: "New Todo",
            child: Icon(Icons.add),
          ),
        );
      },
    );
  }
}

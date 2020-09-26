import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sagar_sqflite/backgroundColor.dart';
import 'package:sagar_sqflite/scoped_model/todo_list_model.dart';
import 'package:sagar_sqflite/screens/add_project_screen.dart';
import 'package:sagar_sqflite/screens/detail_screen.dart';
import 'package:sagar_sqflite/task_progress_indicator.dart';
import 'package:sagar_sqflite/util/color_utility.dart';
import 'package:sagar_sqflite/util/datetime_util.dart';
import 'package:scoped_model/scoped_model.dart';
import 'model/hero_id_model.dart';
import 'model/task.dart';
import 'model/todo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var app = MaterialApp(
        title: 'Todo List App',
        theme: ThemeData(
          textTheme: TextTheme(
            headline5: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
            headline6: TextStyle(fontSize: 28, fontWeight: FontWeight.w500),
            bodyText1: TextStyle(fontSize: 14),
          ),
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: MyHomePage());
    return ScopedModel<TodoListModel>(model: TodoListModel(), child: app);
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  HeroId _generateHeroIds(Task task) {
    return HeroId(
        titleId: 'title_id_${task.id}',
        progressId: 'progress_id_${task.id}',
        remainingTaskId: 'remaining_task_id_${task.id}');
  }

  String currentDay(context) {
    return DateTimeUtils.currentDate;
  }

  AnimationController _controller;
  Animation<double> _animation;
  final GlobalKey _backDropKey = GlobalKey(debugLabel: 'Backdrop');
  PageController _pagecontroller;
  int _currentPageIndex = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    _pagecontroller = PageController(initialPage: 0, viewportFraction: 0.8);
  }

// This will help us dispose animation
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<TodoListModel>(
      builder: (context, child, model) {
        var _isLoading = model.isLoading;
        var _tasks = model.tasks;
        var _todos = model.todos;
        var backgroundColor = _tasks.isEmpty ||
                _tasks.length == _currentPageIndex
            ? Colors.blueGrey
            : ColorsUtility.getColorFrom(id: _tasks[_currentPageIndex].color);

        if (!_isLoading) {
          _controller.forward();
        }

        return BackgroundColor(
          color: backgroundColor,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: _isLoading
                ? Center(
                    child: CupertinoActivityIndicator(
                      animating: true,
                    ),
                  )
                : FadeTransition(
                    opacity: _animation,
                    child: Column(
                      children: [
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  '${currentDay(context)}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  '${DateTimeUtils.currentDate}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 16,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          key: _backDropKey,
                          flex: 1,
                          child: PageView.builder(
                            controller: _pagecontroller,
                            itemCount: _tasks.length + 1,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == _tasks.length) {
                                // if it's empty give us Add Page Card
                                return AddPageCard(color: Colors.grey);
                              } else {
                                // if it is not empty then give us some data
                                return TaskCard(
                                  color: ColorsUtility.getColorFrom(
                                      id: _tasks[index].color),
                                  model: model,
                                  todos: model.todos,
                                  task: _tasks[index],
                                  getHeroId: _generateHeroIds,
                                  getTaskCompletionPercent:
                                      model.getTaskCompletionPercentage,
                                  getTotalTodos: model.getTotalTodoFrom,
                                );
                              }
                            },
                          ),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                      ],
                    ),
                  ),
          ),
        );
      },
    );
  }
}

class AddPageCard extends StatelessWidget {
  final Color color;

  const AddPageCard({Key key, @required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddProjectScreen()));
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add,
                size: 52,
                color: color,
              ),
              SizedBox(
                height: 8,
              ),
              Text('Add a project', style: TextStyle(color: color))
            ],
          ),
        ),
      ),
    );
  }
}

// typedef is used to create a function type that can be used as notation for
// declaring variable & return Function Type

typedef TaskGetter<T, V> = V Function(T value);

class TaskCard extends StatelessWidget {
  final Task task;
  final Color color;
  final List<Todo> todos;
  final TodoListModel model;

  final TaskGetter<Task, int> getTotalTodos;
  final TaskGetter<Task, HeroId> getHeroId;
  final TaskGetter<Task, int> getTaskCompletionPercent;

  const TaskCard(
      {Key key,
      @required this.task,
      @required this.color,
      @required this.todos,
      @required this.getTotalTodos,
      @required this.getHeroId,
      @required this.getTaskCompletionPercent,
      @required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // this variable will help us check the ID for todo

    var _todos = todos.where((element) => element.parent == task.id).toList();
    var heroIds = getHeroId(task);

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailScreen(taskId: task.id)));
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Hero(
                  tag: heroIds.remainingTaskId,
                  child: Text(
                    '${getTotalTodos(task)}',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              Container(
                child: Hero(
                  tag: heroIds.titleId,
                  child: Text(
                    task.name,
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              /*Hero(
                tag: heroIds.progressId,
                child: TaskProgressIndicator(
                  color: color,
                  progress: getTaskCompletionPercent(task),
                ),
              ),*/
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: _todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    if (index == todos.length) {
                      return SizedBox(height: 56);
                    }
                    var todo = _todos[index];
                    return Container(
                      padding: EdgeInsets.only(left: 22, right: 22),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        leading: Checkbox(
                            value: todo.isCompleted == 1 ? true : false,
                            onChanged: (value) => model.updateTodo(
                                todo.copy(isCompleted: value ? 1 : 0))),
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
        ),
      ),
    );
  }
}

// ASK SAGAR THIS

/*

  var _todos = todos.where((element) => element.parent == task.id).toList();


*/

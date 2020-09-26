import 'package:sagar_sqflite/database/database_provider.dart';
import 'package:sagar_sqflite/database/database_provider.dart';
import 'package:sagar_sqflite/model/task.dart';
import 'package:sagar_sqflite/model/todo.dart';
import 'package:scoped_model/scoped_model.dart';

class TodoListModel extends Model {
  var _db = DBProvider.db;

  List<Task> _tasks = [];
  List<Todo> _todos = [];

  List<Task> get tasks => _tasks.toList();
  List<Todo> get todos => _todos.toList();

  Map<String, int> _taskCompletionPercentage = Map();

  int getTotalTodoFrom(Task task) =>
      todos.where((element) => element.parent == task.id).length;

  int getTaskCompletionPercentage(Task task) =>
      _taskCompletionPercentage[task.id];

/*

int getTaskCompletionPercentage(Task task) {

 return _taskCompletionPercentage[task.id];

}


*/

//Loading Bar

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  @override
  void addListener(listener) {
    // TODO: implement addListener
    super.addListener(listener);
    _isLoading = true;
    loadTodo();
    notifyListeners();
  }

  void loadTodo() async {
    var isNew = !await DBProvider.db.dbExists();
    if (isNew) {
      await _db.insertBulkTask(_db.tasks);
      await _db.insertBulkTodo(_db.todos);
    }
    _tasks = await _db.getAllTask();
    _todos = await _db.getAllTodo();
    _isLoading = false;
    Future.delayed(Duration(milliseconds: 500));
    notifyListeners();
  }

  // Write update delete data methods
  void insertTask(Task task) {
    // temp data
    _tasks.add(task);

    // mobile local storage
    _db.insertTask(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    // Always right hand side value is stored in left hand side
    var oldID = _tasks.firstWhere((element) => element.id == task.id);
    var newID = _tasks.indexOf(oldID);
    _tasks.replaceRange(newID, newID + 1, [task]);
    _db.updateTask(task);
    notifyListeners();
  }

  void deleteTask(Task task) {
    _db.removeTask(task).then((_) {
      //delete task
      _tasks.removeWhere((element) => element.id == task.id);
      // delete todo
      _todos.removeWhere((element) => element.parent == task.id);
      notifyListeners();
    });
  }

  void insertTodo(Todo todo) {
    _todos.add(todo);
    _db.insertTodo(todo);
    notifyListeners();
  }

  void updateTodo(Todo todo) {
    var oldTODO = _todos.firstWhere((element) => element.id == todo.id);
    var newID = todos.indexOf(oldTODO);
    _todos.replaceRange(newID, newID + 1, [todo]);
    _syncJob(todo);
    _db.updateTodo(todo);
    notifyListeners();
  }

  void deleteTodo(Todo todo) {
    _todos.removeWhere((element) => element.id == todo.id);
    _db.removeTodo(todo);
    notifyListeners();
  }

  _syncJob(Todo todo) {
    _calculateTaskCompletionPercentage(todo.parent);
  }

  void _calculateTaskCompletionPercentage(String taskId) {
    var todos = this.todos.where((element) => element.parent == taskId);
    var totalTodos = todos.length;
    if (totalTodos == 0) {
      _taskCompletionPercentage[taskId] = 0;
    } else {
      var totalCompletedTodos =
          todos.where((element) => element.isCompleted == 1).length;
      _taskCompletionPercentage[taskId] =
          (totalCompletedTodos / totalTodos * 100).toInt();
    }
  }
}

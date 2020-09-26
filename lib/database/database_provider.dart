import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sagar_sqflite/model/task.dart';
import 'package:sagar_sqflite/model/todo.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

/*
class DBProvider {
  static Database _database;
  String _dbName = "Todo.db";

  // singleton Class

  DBProvider._();
  static DBProvider db = DBProvider._();

// Tasks are projects
  var tasks = [
    Task("Login app", id: '1', color: Colors.green.value),
    Task("Music project", id: '2', color: Colors.blue.value),
  ];
  var todos = [
    // parent is project number
    Todo("First do design", parent: '1'),
    Todo("Create login page", parent: '1'),
    Todo("Add Google sign ine", parent: '1'),
    Todo("Cmpose music", parent: '2'),
    Todo("Arrange music", parent: '2'),
    Todo("Write scores", parent: '3'),
  ];

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initializeDatabase();
    return _database;
  }

  Future<String> get _getPath async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _dbName;
    return p.join(path);
  }

  initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + _dbName;
    await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (db, version) async {
        await db.execute("CREATE TABLE Task ("
            "id TEXT PRIMARY KEY,"
            "name TEXT,"
            "color INTEGER,"
            ")");

        await db.execute("CREATE TABLE Todo ("
            "id TEXT PRIMARY KEY,"
            "name TEXT,"
            "parent TEXT,"
            "completed INTEGER NOT NULL DEFAULT 0"
            ")");
      },
    );
  }

  Future<bool> dbExists() async {
    return File(await _getPath).exists();
  }

  insertBulkTask(List<Task> task) async {
    final db = await database;
    task.forEach((element) async {
      var response = await db.insert("task", element.toJson());
      print('Task ${element.id} = $response');
    });
  }

  insertBulkTodo(List<Todo> todo) async {
    final db = await database;
    todo.forEach((element) async {
      var response = await db.insert("todo", element.toJson());
      print('Todo ${element.id} = $response');
    });
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await database;
    var result = await db.query('todo');
    return result.map((it) => Todo.fromJson(it)).toList();
  }

  Future<List<Task>> getAllTask() async {
    final db = await database;
    var result = await db.query('task');
    return result.map((it) => Task.fromJson(it)).toList();
  }

// insert function
  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return db.insert('Todo', todo.toJson());
  }

// update function
  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return db.update(
      'Todo',
      todo.toJson(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  Future<int> deleteTodo(Todo todo) async {
    final db = await database;
    return db.delete(
      'Todo',
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // insert function
  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('Task', task.toJson());
  }

// update function
  Future<int> updateTask(Task task) async {
    final db = await database;
    return db.update(
      'Task',
      task.toJson(),
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }

  // Future<void> deleteTask(Task task) async {
  //   final db = await database;
  //   return db.transaction<void>((txn) async{
  //     await txn.delete(
  //       'Todo',
  //       where : 'parent = ?',
  //       whereArgs: [task.id]
  //   );
  //   )
  //   } }

  Future<void> deleteTask(Task task) async {
    final db = await database;
    return db.transaction<void>((txn) async {
      await txn.delete(
        'Todo',
        where: 'parent = ?',
        whereArgs: [task.id],
      );
      await txn.delete(
        'Task',
        where: 'id = ?',
        whereArgs: [task.id],
      );
    });
  }

  // insertBulkList

  // delete function

}
*/

class DBProvider {
  static Database _database;

  DBProvider._();
  static final DBProvider db = DBProvider._();

  var todos = [
    Todo(
      "Vegetables",
      parent: '1',
    ),
    Todo(
      "Birthday gift",
      parent: '1',
    ),
    Todo("Chocolate cookies", parent: '1', isCompleted: 1),
    Todo(
      "20 pushups",
      parent: '2',
    ),
    Todo(
      "Tricep",
      parent: '2',
    ),
    Todo(
      "15 burpees (3 sets)",
      parent: '2',
    ),
  ];

  var tasks = [
    Task(
      'Shopping',
      id: '1',
      color: Colors.purple.value,
      //codePoint: Icons.shopping_cart.codePoint
    ),
    Task(
      'Workout',
      id: '2',
      color: Colors.pink.value,
      //codePoint: Icons.fitness_center.codePoint
    ),
  ];

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  get _dbPath async {
    String documentsDirectory = await _localPath;
    return p.join(documentsDirectory, "Todo.db");
  }

  Future<bool> dbExists() async {
    return File(await _dbPath).exists();
  }

  initDB() async {
    String path = await _dbPath;
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      print("DBProvider:: onCreate()");
      await db.execute("CREATE TABLE Task ("
          "id TEXT PRIMARY KEY,"
          "name TEXT,"
          "color INTEGER,"
          "code_point INTEGER"
          ")");
      await db.execute("CREATE TABLE Todo ("
          "id TEXT PRIMARY KEY,"
          "name TEXT,"
          "parent TEXT,"
          "completed INTEGER NOT NULL DEFAULT 0"
          ")");
    });
  }

  insertBulkTask(List<Task> tasks) async {
    final db = await database;
    tasks.forEach((it) async {
      var res = await db.insert("Task", it.toJson());
      print("Task ${it.id} = $res");
    });
  }

  insertBulkTodo(List<Todo> todos) async {
    final db = await database;
    todos.forEach((it) async {
      var res = await db.insert("Todo", it.toJson());
      print("Todo ${it.id} = $res");
    });
  }

  Future<List<Task>> getAllTask() async {
    final db = await database;
    var result = await db.query('Task');
    return result.map((it) => Task.fromJson(it)).toList();
  }

  Future<List<Todo>> getAllTodo() async {
    final db = await database;
    var result = await db.query('Todo');
    return result.map((it) => Todo.fromJson(it)).toList();
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    return db
        .update('Todo', todo.toJson(), where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> removeTodo(Todo todo) async {
    final db = await database;
    return db.delete('Todo', where: 'id = ?', whereArgs: [todo.id]);
  }

  Future<int> insertTodo(Todo todo) async {
    final db = await database;
    return db.insert('Todo', todo.toJson());
  }

  Future<int> insertTask(Task task) async {
    final db = await database;
    return db.insert('Task', task.toJson());
  }

  Future<void> removeTask(Task task) async {
    final db = await database;
    return db.transaction<void>((txn) async {
      await txn.delete('Todo', where: 'parent = ?', whereArgs: [task.id]);
      await txn.delete('Task', where: 'id = ?', whereArgs: [task.id]);
    });
  }

  Future<int> updateTask(Task task) async {
    final db = await database;
    return db
        .update('Task', task.toJson(), where: 'id = ?', whereArgs: [task.id]);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  closeDB() {
    if (_database != null) {
      _database.close();
    }
  }
}

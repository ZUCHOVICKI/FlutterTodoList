import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:reminders_flutter/models/models.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static dynamic _database;

  static final DBProvider db = DBProvider._();
  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentsDirectory.path, 'Todo.db');

    return await openDatabase(path, version: 4,
        onCreate: (Database db, int version) async {
      await db.execute('''
          CREATE TABLE Todo(
            id INTEGER PRIMARY KEY,
            title TEXT,
            description TEXT,
            date TEXT,
            done INTEGER,
            todoList INTEGER
          );''');
      await db.execute('''
          CREATE TABLE TodoList(
            id INTEGER PRIMARY KEY,
            title TEXT,
            date TEXT,
            urgency INTEGER
          );
        ''');
    });
  }

  Future<int> newTodo(Todo newTodo) async {
    final db = await database;

    final response = await db.insert('Todo', newTodo.toMap());

    return response;
  }

  Future<List<Todo>?> getAllTodo() async {
    final db = await database;
    final response = await db.query('Todo');

    return response.isNotEmpty
        ? response.map((e) => Todo.fromMap(e)).toList()
        : [];
  }

  Future<List<Todo>?> getTodoByList(int todoList) async {
    final db = await database;
    final response =
        await db.rawQuery("Select * from Todo where todoList = ?", [todoList]);

    return response.isNotEmpty
        ? response.map((e) => Todo.fromMap(e)).toList()
        : [];
  }

  Future<int> deleteTodo(int id) async {
    final db = await database;
    final res = await db.delete('Todo', where: 'id=?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteTodoByList(int listId) async {
    final db = await database;
    final res =
        await db.delete('Todo', where: 'todoList=?', whereArgs: [listId]);
    return res;
  }

  Future<int> updateTodo(Todo nuevoTodo) async {
    final db = await database;
    final res = await db.update('Todo', nuevoTodo.toMap(),
        where: 'id=?', whereArgs: [nuevoTodo.id]);

    return res;
  }

// TODOLIST
  Future<int> newTodolist(TodoList newTodoList) async {
    final db = await database;

    final response = await db.insert('TodoList', newTodoList.toMap());

    return response;
  }

  Future<List<TodoList>?> getAllTodoList() async {
    final db = await database;
    final response = await db.query('TodoList');

    return response.isNotEmpty
        ? response.map((e) => TodoList.fromMap(e)).toList()
        : [];
  }

  Future<int> deleteTodoList(int id) async {
    final db = await database;
    final res = await db.delete('TodoList', where: 'id=?', whereArgs: [id]);
    return res;
  }

  Future<int> updateTodoList(TodoList nuevoTodoList) async {
    final db = await database;
    final res = await db.update('TodoList', nuevoTodoList.toMap(),
        where: 'id=?', whereArgs: [nuevoTodoList.id]);

    return res;
  }
}

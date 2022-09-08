import 'package:flutter/cupertino.dart';
import 'package:reminders_flutter/services/db_services.dart';

import '../models/models.dart';

class TodoProvider extends ChangeNotifier {
  String todoTitle = "";
  String todoDesc = "";
  List<Todo> todos = [];
  bool _checkBox = false;

  bool get checkbox => _checkBox;

  set checkbox(bool checkbox) {
    _checkBox = checkbox;
    // notifyListeners();
  }

  getAllTodo(int todoListID) async {
    final allTodos = await DBProvider.db.getTodoByList(todoListID);
    todos.clear();
    todos = [...?allTodos];

    notifyListeners();
  }

  newTodo(String title, String date, String description, int done,
      int todoList) async {
    final newTodo = Todo(
        title: title,
        description: description,
        date: date,
        done: done,
        todoList: todoList);
    final id = await DBProvider.db.newTodo(newTodo);

    newTodo.id = id;

    getAllTodo(todoList);

    notifyListeners();
  }

  deleteTodo(int id) async {
    await DBProvider.db.deleteTodo(id);
  }

  changeDone(int index) async {
    if (todos[index].done == 0) {
      todos[index].done = 1;
    } else {
      todos[index].done = 0;
    }

    await DBProvider.db.updateTodo(todos[index]);
    notifyListeners();
  }

  deleteDone(List<Todo> todoList) async {
    for (var x in todoList) {
      if (x.done == 1) {
        await DBProvider.db.deleteTodo(x.id!);
      }
    }
  }

  updateTodo(Todo todo) async {
    await DBProvider.db.updateTodo(todo);
    notifyListeners();
  }
}

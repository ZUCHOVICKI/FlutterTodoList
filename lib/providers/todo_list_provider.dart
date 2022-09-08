import 'package:flutter/cupertino.dart';
import 'package:reminders_flutter/services/db_services.dart';

import '../models/models.dart';

class TodoListProvider extends ChangeNotifier {
  int loaded = 0;
  String todoListTitle = "";
  List<TodoList> _todoList = [];

  List<TodoList> get todoList => _todoList;

  int _urgency = 0;

  Duration _duration = const Duration(hours: 0, minutes: 0);

  Duration get duration => _duration;
  set duration(Duration duration) {
    _duration = duration;
    notifyListeners();
  }

  int get urgency => _urgency;
  set urgency(int urgency) {
    _urgency = urgency;
    notifyListeners();
  }

  set todoList(List<TodoList> todoList) {
    _todoList = todoList;
    // notifyListeners();
  }

  Map<int, int> todoListUrgency = {};

  reDraw() {
    notifyListeners();
  }

  getAllTodoList() async {
    final allTodoList = await DBProvider.db.getAllTodoList();

    final finalList = [...?allTodoList];

    todoList = finalList;

    notifyListeners();
  }

  newTodoList(String title, String date, int urgency) async {
    final newTodoList = TodoList(title: title, date: date, urgency: urgency);
    final id = await DBProvider.db.newTodolist(newTodoList);

    newTodoList.id = id;

    getAllTodoList();

    notifyListeners();
  }

  deleteTodoList(int id) async {
    await DBProvider.db.deleteTodoList(id);

    await DBProvider.db.deleteTodoByList(id);
  }

  updateTodoList(TodoList nuevoTodoList) async {
    await DBProvider.db.updateTodoList(nuevoTodoList);
    notifyListeners();
  }
}

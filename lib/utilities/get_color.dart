import 'package:flutter/material.dart';

import '../models/models.dart';

getTodoListColor(TodoList todoList) {
  switch (todoList.urgency) {
    case 1:
      return Colors.green;
    case 2:
      return Colors.amber;
    case 3:
      return Colors.red;
    default:
      return Colors.blue;
  }
}

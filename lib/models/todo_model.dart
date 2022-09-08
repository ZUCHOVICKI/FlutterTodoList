// To parse this JSON data, do
//
//     final todo = todoFromMap(jsonString);

import 'dart:convert';

class Todo {
  Todo({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.done,
    required this.todoList,
  });

  int? id;
  String title;
  String description;
  String date;
  int done;
  int todoList;

  factory Todo.fromJson(String str) => Todo.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Todo.fromMap(Map<String, dynamic> json) => Todo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        date: json["date"],
        done: json["done"],
        todoList: json["todoList"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "date": date,
        "done": done,
        "todoList": todoList,
      };
}

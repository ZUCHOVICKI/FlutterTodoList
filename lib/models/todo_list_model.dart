// To parse this JSON data, do
//
//     final todoList = todoListFromMap(jsonString);

import 'dart:convert';

class TodoList {
  TodoList(
      {this.id,
      required this.title,
      required this.date,
      required this.urgency});

  int? id;
  String title;
  String date;
  int urgency;

  factory TodoList.fromJson(String str) => TodoList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory TodoList.fromMap(Map<String, dynamic> json) => TodoList(
        id: json["id"],
        title: json["title"],
        date: json["date"],
        urgency: json['urgency'],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "date": date,
        "urgency": urgency,
      };
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminders_flutter/providers/providers.dart';

import '../UI/ui.dart';

class NewTodoDialog extends StatelessWidget {
  NewTodoDialog({
    Key? key,
    this.lowUrgency,
    this.midUrgency,
    this.highUrgency,
  }) : super(key: key);

  bool? lowUrgency;
  bool? midUrgency;
  bool? highUrgency;

  @override
  Widget build(BuildContext context) {
    TodoListProvider todoListProvider = context.watch<TodoListProvider>();
    if (todoListProvider.urgency == 1) {
      lowUrgency = true;
      midUrgency = false;
      highUrgency = false;
    }
    if (todoListProvider.urgency == 2) {
      lowUrgency = false;
      midUrgency = true;
      highUrgency = false;
    }

    if (todoListProvider.urgency == 3) {
      lowUrgency = false;
      midUrgency = false;
      highUrgency = true;
    }

    return AlertDialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 70, vertical: 250),
      title: const Text("New ToDoList"),
      content: Column(
        children: [
          TextFormField(
            autocorrect: false,
            decoration: InputDecorationsUI.uIInputDecoration(
                hintText: "Title", labelText: "Title"),
            onChanged: (value) {
              todoListProvider.todoListTitle = value;
            },
          ),
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: lowUrgency,
                    onChanged: (value) {
                      if (value!) {
                        todoListProvider.urgency = 1;
                      }
                    },
                    activeColor: Colors.green,
                  ),
                  const Text("!")
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: midUrgency,
                    onChanged: (value) {
                      if (value!) {
                        todoListProvider.urgency = 2;
                      }
                    },
                    activeColor: Colors.amber,
                  ),
                  const Text("!!")
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: highUrgency,
                    onChanged: (value) {
                      if (value!) {
                        todoListProvider.urgency = 3;
                      }
                    },
                    activeColor: Colors.red,
                  ),
                  const Text("!!!")
                ],
              ),
            ],
          )
        ],
      ),
      actions: <Widget>[
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.green),
            onPressed: () {
              DateTime today = DateTime.now();
              String formattedDate = DateFormat('dd/MM/yy').format(today);
              todoListProvider.newTodoList(todoListProvider.todoListTitle,
                  formattedDate, todoListProvider.urgency);
              todoListProvider.urgency = 0;
              Navigator.pop(context);
            },
            child: const Text("ADD")),
        ElevatedButton(
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("CANCEL"))
      ],
    );
  }
}

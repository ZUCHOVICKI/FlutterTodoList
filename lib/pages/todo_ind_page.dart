import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminders_flutter/providers/providers.dart';
import 'package:reminders_flutter/utilities/get_color.dart';

import '../UI/ui.dart';
import '../models/models.dart';

class TodoIndScreen extends StatelessWidget {
  const TodoIndScreen({Key? key}) : super(key: key);
  final routeName = 'TodoIndScreen';
  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = Provider.of<TodoProvider>(context);

    List<dynamic> arguments =
        ModalRoute.of(context)?.settings.arguments as List<dynamic>;
    Todo individualTodo = arguments[0];
    TodoList todoList = arguments[1];
    if (individualTodo.done == 0) {
      todoProvider.checkbox = false;
    } else {
      todoProvider.checkbox = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(individualTodo.title),
        backgroundColor: getTodoListColor(todoList),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              decoration: InputDecorationsUI.uIInputDecoration(
                  hintText: "Title ", labelText: "Title"),
              initialValue: individualTodo.title,
              onChanged: (value) {
                individualTodo.title = value;
              },
            ),
            const SizedBox(
              height: 50,
            ),
            TextFormField(
              maxLines: 10,
              autocorrect: false,
              decoration: InputDecorationsUI.uIInputDecoration(
                  hintText: "Description ", labelText: "Description"),
              initialValue: individualTodo.description,
              onChanged: (value) {
                individualTodo.description = value;
              },
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  individualTodo.date,
                  style: const TextStyle(fontSize: 20),
                ),
                Checkbox(
                  value: todoProvider.checkbox,
                  onChanged: (value) {
                    todoProvider.checkbox = value!;
                    if (value) {
                      individualTodo.done = 1;
                    } else {
                      individualTodo.done = 0;
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          todoProvider.updateTodo(individualTodo);
          Navigator.pop(context);
        },
        child: const Icon(Icons.save),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:reminders_flutter/pages/pages.dart';
import 'package:reminders_flutter/providers/todo_provider.dart';
import 'package:reminders_flutter/utilities/get_color.dart';

import '../UI/ui.dart';
import '../models/models.dart';

class TodoScreen extends StatelessWidget {
  const TodoScreen({Key? key}) : super(key: key);
  final routeName = 'TodoScreen';
  @override
  Widget build(BuildContext context) {
    TodoProvider todoProvider = Provider.of<TodoProvider>(context);

    TodoList parentTodoList =
        ModalRoute.of(context)?.settings.arguments as TodoList;

    todoProvider.getAllTodo(parentTodoList.id!);

    return Scaffold(
      appBar: AppBar(
        title: Text(parentTodoList.title),
        backgroundColor: getTodoListColor(parentTodoList),
        actions: [
          IconButton(
              onPressed: () {
                List<Todo> listTodos = [];

                for (var x in todoProvider.todos) {
                  if (x.todoList == parentTodoList.id) {
                    listTodos.add(x);
                  }
                }
                todoProvider.deleteDone(listTodos);
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            leading: const Icon(Icons.star),
            onLongPress: () {
              todoProvider.changeDone(index);
            },
            onTap: () => Navigator.pushNamed(
                context, const TodoIndScreen().routeName,
                arguments: [todoProvider.todos[index], parentTodoList]),
            title: _strikeThroughTitle(context, index, todoProvider),
            subtitle: _strikeThroughDesc(context, index, todoProvider),
          ),
        ),
        itemCount: todoProvider.todos.length,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: getTodoListColor(parentTodoList),
        onPressed: () => _newTodo(context, todoProvider, parentTodoList),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<dynamic> _newTodo(
    BuildContext context, TodoProvider todoProvider, TodoList todoList) {
  return showAnimatedDialog(
      context: context,
      builder: (context) => SingleChildScrollView(
            child: AlertDialog(
              title: const Text("New ToDo"),
              insetPadding:
                  const EdgeInsets.symmetric(horizontal: 70, vertical: 200),
              content: Column(
                children: [
                  TextFormField(
                    autocorrect: false,
                    decoration: InputDecorationsUI.uIInputDecoration(
                        hintText: "Title", labelText: "Title"),
                    onChanged: (value) {
                      todoProvider.todoTitle = value;
                    },
                  ),
                  TextFormField(
                    autocorrect: false,
                    maxLines: 5,
                    decoration: InputDecorationsUI.uIInputDecoration(
                        hintText: "Description ", labelText: "Description"),
                    onChanged: (value) {
                      todoProvider.todoDesc = value;
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                    onPressed: () {
                      DateTime today = DateTime.now();
                      String formattedDate =
                          DateFormat('dd/MM/yy').format(today);
                      todoProvider.newTodo(
                          todoProvider.todoTitle,
                          formattedDate,
                          todoProvider.todoDesc,
                          0,
                          todoList.id!);

                      Navigator.pop(context);
                    },
                    child: const Text("ADD")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("CANCEL")),
              ],
            ),
          ),
      animationType: DialogTransitionType.scale,
      duration: const Duration(milliseconds: 700),
      curve: Curves.bounceInOut);
}

_strikeThroughTitle(
    BuildContext context, int index, TodoProvider todoProvider) {
  if (todoProvider.todos[index].done == 1) {
    return Text(
      todoProvider.todos[index].title,
      style: const TextStyle(decoration: TextDecoration.lineThrough),
    );
  }
  return Text(
    todoProvider.todos[index].title,
  );
}

_strikeThroughDesc(BuildContext context, int index, TodoProvider todoProvider) {
  if (todoProvider.todos[index].done == 1) {
    return Text(
      todoProvider.todos[index].description,
      style: const TextStyle(decoration: TextDecoration.lineThrough),
      maxLines: 1,
      overflow: TextOverflow.fade,
    );
  }
  return Text(
    todoProvider.todos[index].description,
    maxLines: 1,
    overflow: TextOverflow.fade,
  );
}

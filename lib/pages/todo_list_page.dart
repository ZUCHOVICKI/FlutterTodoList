// import 'package:duration_picker/duration_picker.dart';
import 'package:duration_picker/duration_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_alarm_clock/flutter_alarm_clock.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:provider/provider.dart';
import 'package:reminders_flutter/models/models.dart';
import 'package:reminders_flutter/pages/pages.dart';
import 'package:reminders_flutter/providers/todo_list_provider.dart';
import 'package:reminders_flutter/widgets/widgets.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({Key? key}) : super(key: key);

  final routeName = 'MainScreen';

  @override
  Widget build(BuildContext context) {
    TodoListProvider todoListProvider = Provider.of<TodoListProvider>(context);

    if (todoListProvider.todoList.isEmpty) {
      todoListProvider.getAllTodoList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("ToDo List"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, const SettingsScreen().routeName);
              },
              icon: const Icon(Icons.settings))
        ],
      ),
      body: ListView.builder(
        itemBuilder: (context, index) => Dismissible(
          background: Container(
            color: Colors.red,
            child: Stack(
              children: const [
                Positioned(
                  top: 0,
                  left: 50,
                  child: Icon(
                    Icons.delete_forever,
                    size: 60,
                  ),
                ),
              ],
            ),
          ),
          key: UniqueKey(),
          onDismissed: (direction) {
            todoListProvider
                .deleteTodoList(todoListProvider.todoList[index].id!);
            // print(tests[index].id);
          },
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: ListTile(
              iconColor: _urgencyColor(index, todoListProvider),
              leading: const Icon(Icons.alarm),
              trailing: const Icon(Icons.arrow_forward),
              onTap: () => Navigator.pushNamed(
                context,
                const TodoScreen().routeName,
                arguments: todoListProvider.todoList[index],
              ),
              onLongPress: () {
                _editTodoList(context, todoListProvider,
                    todoListProvider.todoList[index]);
              },
              title: Text(
                todoListProvider.todoList[index].title,
              ),
              subtitle: Text(todoListProvider.todoList[index].date),
            ),
          ),
        ),
        itemCount: todoListProvider.todoList.length,
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: null,
            onPressed: () => _newTodoList(context, todoListProvider),
            child: const Icon(Icons.add),
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            heroTag: null,
            onPressed: () async {
              TimeOfDay now = TimeOfDay.now();
              final TimeOfDay? alarmTime =
                  await showTimePicker(context: context, initialTime: now);
              // FlutterAlarmClock.createAlarm(hour, minutes)

              if (alarmTime?.hour != null && alarmTime?.minute != null) {
                FlutterAlarmClock.createAlarm(
                    alarmTime!.hour, alarmTime.minute);
              }
            },
            child: const Icon(Icons.alarm),
          ),
          const SizedBox(
            height: 5,
          ),
          FloatingActionButton(
            onPressed: () async {
              var resultingDuration = await showDurationPicker(
                  context: context,
                  initialTime: const Duration(minutes: 30),
                  snapToMins: 5.0);

              FlutterAlarmClock.createTimer(resultingDuration!.inSeconds);
            },
            heroTag: null,
            child: const Icon(Icons.timer),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

Future<dynamic> _newTodoList(
    BuildContext context, TodoListProvider todoListProvider) {
  bool lowUrgency = false;
  bool midUrgency = false;
  bool highUrgency = false;

  return showAnimatedDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
            value: todoListProvider,
            child: SingleChildScrollView(
              child: NewTodoDialog(
                  lowUrgency: lowUrgency,
                  midUrgency: midUrgency,
                  highUrgency: highUrgency),
            ),
          ),
      animationType: DialogTransitionType.scale,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.bounceInOut);
}

Future<dynamic> _editTodoList(BuildContext context,
    TodoListProvider todoListProvider, TodoList todoList) {
  bool lowUrgency = false;
  bool midUrgency = false;
  bool highUrgency = false;

  return showAnimatedDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) => ChangeNotifierProvider.value(
            value: todoListProvider,
            child: SingleChildScrollView(
              child: EditTodoDialog(
                  lowUrgency: lowUrgency,
                  midUrgency: midUrgency,
                  highUrgency: highUrgency,
                  todoList: todoList),
            ),
          ),
      animationType: DialogTransitionType.scale,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.bounceInOut);
}

_urgencyColor(int index, TodoListProvider todoListProvider) {
  switch (todoListProvider.todoList[index].urgency) {
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

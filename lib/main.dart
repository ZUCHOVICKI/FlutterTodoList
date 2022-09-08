import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reminders_flutter/pages/pages.dart';
import 'package:reminders_flutter/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => TodoListProvider()),
    ChangeNotifierProvider(create: (context) => TodoProvider()),
    ChangeNotifierProvider(
      create: (context) => ColorProvider(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ColorProvider colorProvider = Provider.of<ColorProvider>(context);
    getColorFromint(context, colorProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: colorProvider.customSwatch ?? Colors.blue,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: colorProvider.currentColor ?? Colors.blue,
          )),
      initialRoute: const TodoListScreen().routeName,
      routes: {
        const TodoListScreen().routeName: (context) => const TodoListScreen(),
        const TodoScreen().routeName: (context) => const TodoScreen(),
        const TodoIndScreen().routeName: (context) => const TodoIndScreen(),
        const AddTodoScreen().routeName: (context) => const AddTodoScreen(),
        const SettingsScreen().routeName: (context) => const SettingsScreen(),
      },
    );
  }
}

getColorFromint(BuildContext context, ColorProvider colorProvider) async {
  if (colorProvider.currentColor == null) {
    final prefs = await SharedPreferences.getInstance();

    int colorValue = prefs.getInt('color') ?? 0;

    if (colorValue != 0) {
      colorProvider.getColorFromInt(colorValue);

      colorProvider.getColorSwatch(colorProvider.currentColor!);
    }
  }
}

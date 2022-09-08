import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';
import 'package:reminders_flutter/providers/providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  final routeName = 'SettingsScreen';
  @override
  Widget build(BuildContext context) {
    ColorProvider colorProvider = Provider.of<ColorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: colorProvider.currentColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 100),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            colorProvider.currentColor ?? Colors.blue)),
                    onPressed: () {
                      _getColorPicker(context, colorProvider);
                    },
                    child: const Text("Change Main Color")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

_getColorPicker(BuildContext context, ColorProvider colorProvider) {
// create some values
  Color pickerColor = colorProvider.currentColor ?? Colors.blue;
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Pick a color!'),
      content: SingleChildScrollView(
        child: MaterialPicker(
          pickerColor: pickerColor,
          onColorChanged: (color) async {
            colorProvider.currentColor = color;
            final prefs = await SharedPreferences.getInstance();

            await prefs.setInt('color', colorProvider.currentColor?.value ?? 0);

            colorProvider.getColorSwatch(colorProvider.currentColor!);
          },
        ),
      ),
    ),
  );
}

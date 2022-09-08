import 'package:flutter/material.dart';

class ColorProvider extends ChangeNotifier {
  Color? _currentColor;

  Color? get currentColor => _currentColor;

  set currentColor(Color? color) {
    _currentColor = color;
    notifyListeners();
  }

  MaterialColor? _customSwatch;

  MaterialColor? get customSwatch => _customSwatch;

  set customSwatch(MaterialColor? color) {
    _customSwatch = color;
    notifyListeners();
  }

  getColorFromInt(int color) {
    currentColor = Color(color);

    notifyListeners();
  }

  getColorSwatch(Color currentColor) {
    int r = currentColor.red;
    int g = currentColor.green;
    int b = currentColor.blue;

    Map<int, Color> color = {
      50: Color.fromRGBO(r, g, b, .1),
      100: Color.fromRGBO(r, g, b, .2),
      200: Color.fromRGBO(r, g, b, .3),
      300: Color.fromRGBO(r, g, b, .4),
      400: Color.fromRGBO(r, g, b, .5),
      500: Color.fromRGBO(r, g, b, .6),
      600: Color.fromRGBO(r, g, b, .7),
      700: Color.fromRGBO(r, g, b, .8),
      800: Color.fromRGBO(r, g, b, .9),
      900: Color.fromRGBO(r, g, b, 1),
    };

    MaterialColor myColor = MaterialColor(currentColor.value, color);
    customSwatch = myColor;
  }
}

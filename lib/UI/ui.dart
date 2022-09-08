import 'package:flutter/material.dart';

class InputDecorationsUI {
  // final color = status ? Colors.green : Colors.red;
  static InputDecoration uIInputDecoration({
    required String hintText,
    required String labelText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      enabledBorder: const UnderlineInputBorder(
        borderSide: BorderSide(),
      ),
      focusedBorder: const UnderlineInputBorder(
        borderSide: BorderSide(
          width: 0,
        ),
      ),
      hintText: hintText,
      labelText: labelText,
      labelStyle: const TextStyle(
        color: Colors.grey,
      ),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
    );
  }
}

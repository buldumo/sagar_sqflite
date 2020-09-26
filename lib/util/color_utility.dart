import 'package:flutter/material.dart';

class ColorsUtility {
  static List<Color> defaultColors = [
    Colors.pink,
    Colors.black,
    Colors.blue,
    Colors.indigo,
    Colors.green,
    Colors.yellow,
    Colors.orange,
  ];

  static Map<int, Color> _colors = Map();

  static Map<int, Color> get colors {
    if (_colors.isNotEmpty) {
      return _colors;
    }

    defaultColors.forEach((color) {
      _colors[color.value] = color;
    });
    return _colors;
  }

  static Color getColorFrom({int id}) {
    return colors.containsKey(id) ? colors[id] : defaultColors[0];
  }
}

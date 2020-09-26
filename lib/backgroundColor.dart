import 'package:flutter/material.dart';

class BackgroundColor extends StatelessWidget {
  final Widget child;
  final Color color;
  const BackgroundColor({Key key, @required this.color, @required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getColorList(color),
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          stops: [0.3, 0.5, 0.7, 0.9],
        ),
      ),
      duration: Duration(milliseconds: 500),
      child: child,
    );
  }

  List<Color> getColorList(Color color) {
    if (color is MaterialColor) {
      return [
        color[300],
        color[500],
        color[700],
        color[900],
      ];
    } else {
      return List<Color>.filled(4, color);
    }
  }
}

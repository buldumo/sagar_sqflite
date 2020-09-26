import 'package:flutter/material.dart';

class TaskProgressIndicator extends StatelessWidget {
  final Color color;
  final progress;

  const TaskProgressIndicator(
      {Key key, @required this.color, @required this.progress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Container(height: 3.0, color: Colors.grey.withOpacity(0.1)),
                  AnimatedContainer(
                    height: 3,
                    width: (progress / 100) * constraints.maxWidth,
                    color: color,
                    duration: Duration(milliseconds: 300),
                  )
                ],
              );
            },
          ),
        ),
        Container(
          child: Text('$progress%', style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }
}

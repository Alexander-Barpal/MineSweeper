import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NumberBox extends StatelessWidget {
  final child;
  bool revealed;
  final function;

  NumberBox({super.key, this.child, required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    Color color;
    switch (child) {
      case 1:
        color = Colors.blue;
      case 2:
        color = Colors.green;
      case 3:
        color = Colors.red;
      case 4:
        color = Colors.purple;
      case 5:
        color = Colors.orange;
      case 6:
        color = Colors.teal;
      case 7:
        color = Colors.yellow;
      default:
        color = Colors.black;
    }

    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: revealed ? Colors.grey[300] : Colors.grey[400],
          child: Center(
            child: Text( 
              revealed ? (child == 0 ? '' : child.toString()) : '',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
                )
              ),  
            )
          ),
        ),
    );
  }
}
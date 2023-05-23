import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Bomb extends StatelessWidget {
  bool revealed;
  final function;

  Bomb({required this.revealed, this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          color: revealed ? Colors.grey[800] : Colors.grey[400],
          child: Center(
            child: Text( 
              revealed ? 'x' : '',
              style: const TextStyle(
                color: Colors.red,
                
              ),
            )
          ),
        ),
      ),
    );
  }
}
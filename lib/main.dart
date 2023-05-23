import 'package:flutter/material.dart';
import 'package:minesweeper/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({ Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

/*

To Do:
-time function
-difficulty selecter
-settings menu
-page switching

*/
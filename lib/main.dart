import 'package:flutter/material.dart';
import 'package:mytodoapp/todocontainer.dart';

void main() {
  runApp(ToDoApp());
}

class ToDoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Todocontainer());
  }
}

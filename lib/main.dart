import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jigsaw_puzzle_demo/jigsaw_puzzle/jigsaw_puzzle_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: JigsawPuzzlePage(),
    );
  }
}

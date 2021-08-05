import 'package:flutter/material.dart';
import 'package:simpleems/bottomNavbar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SimpleEMS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: bottomNavbar(),
    );
  }
}

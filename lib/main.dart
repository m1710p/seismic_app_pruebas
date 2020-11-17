import 'package:flutter/material.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Seismic App',
        home: Home(),
        theme: ThemeData(
          primaryColor: Colors.lightBlue,
          accentColor: Colors.lightBlue,
        ));
  }
}

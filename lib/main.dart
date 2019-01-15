import 'package:flutter/material.dart';
import 'HomeScreen.dart';
import 'SplashScreen.dart';

var routes = <String, WidgetBuilder>{
  "/HomeScreen": (BuildContext context) => HomeScreen(),
};

void main() {
  runApp(new MaterialApp(
      title: 'Wallyfy',
      theme: new ThemeData(
        brightness: Brightness.dark
      ),
      debugShowCheckedModeBanner: false,
      home: new SplashScreen(),
      routes: routes));
}
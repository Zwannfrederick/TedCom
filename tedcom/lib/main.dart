import 'package:flutter/material.dart';
import 'auth_screen.dart'; // auth_screen.dart dosyasını içe aktarın

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TedCom',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: AuthScreen(),
    );
  }
}

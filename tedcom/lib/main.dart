import 'package:flutter/material.dart';
import 'auth_screen.dart'; // auth_screen.dart dosyasını içe aktarın
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Firebase'i başlatıyoruz
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

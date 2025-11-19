import 'package:flutter/material.dart';
import 'pages/Dashboard.dart';
import 'package:myapp/pages/home.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
      routes: {
        '/dashboard': (context) =>
            const Dashboard(), // Définir la route pour le Dashboard
      },
    );
  }
}

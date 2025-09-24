import 'package:flutter/material.dart';
import 'package:ifran/screens/login_screen.dart';
import 'package:ifran/screens/student_login.dart'; // importer la page student_login.dart
import 'package:ifran/screens/parent_login.dart'; // importer la page parent_login.dart
import 'package:ifran/screens/teacher_login.dart'; // importer la page teacher_login.dart
import 'package:ifran/screens/coord_login.dart'; // importer la page coord_login.dart

void main() {
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronote Ifran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
  home: const LoginScreen(),
      routes: {
        '/student_login': (context) => const StudentLogin(), // route pour la page student_login
        '/parent_login': (context) => const ParentLogin(), // route pour la page parent_login
        '/teacher_login': (context) => const TeacherLogin(), // route pour la page teacher_login
        '/coord_login': (context) => const CoordLogin(), // route pour la page coord_login
      },
    );
  }
}

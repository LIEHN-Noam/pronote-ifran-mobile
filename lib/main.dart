import 'package:flutter/material.dart';
import 'package:ifran/screens/login_screen.dart';

// Fonction principale qui lance l'application Flutter
void main() {
  runApp(const MyApp());
}

// Classe principale de l'application, un widget stateless qui définit la structure de base
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Méthode qui construit l'interface de l'application avec MaterialApp
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pronote Ifran',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
    );
  }
}

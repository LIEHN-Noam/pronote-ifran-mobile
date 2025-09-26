import 'package:flutter/material.dart';
import 'package:ifran/screens/common_homepage.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';
  String _selectedType = 'Etudiant';
  bool _isLoading = false;

  final List<String> _userTypes = [
    'Etudiant',
    'Parent',
    'Coordinateur',
    'Enseignant',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 0, 102, 1.0),
        centerTitle: true,
        title: const Text(
          'Pronote IFRAN',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  Image.asset(_getImageForType(_selectedType), height: 60),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    decoration: InputDecoration(
                      labelText: 'Type d’utilisateur',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: const Color.fromRGBO(212, 236, 252, 1.0),
                    ),
                    items: _userTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Identifiant',
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(212, 236, 252, 1.0),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un identifiant';
                            }
                            return null;
                          },
                          onSaved: (value) => _username = value!,
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Mot de passe',
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(212, 236, 252, 1.0),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un mot de passe';
                            }
                            return null;
                          },
                          onSaved: (value) => _password = value!,
                        ),
                        const SizedBox(height: 20),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: _handleLogin,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity, 40),
                                ),
                                child: const Text('Se connecter'),
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getImageForType(String type) {
    switch (type) {
      case 'Etudiant':
        return 'assets/images/eleve.png';
      case 'Parent':
        return 'assets/images/parent.png';
      case 'Coordinateur':
        return 'assets/images/coordinateur.png';
      case 'Enseignant':
        return 'assets/images/enseignant.png';
      default:
        return 'assets/images/login_background.png';
    }
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _isLoading = true);
    bool success = false;
    try {
      switch (_selectedType) {
        case 'Etudiant':
          // TODO: Replace with real login logic and fetch user data
          if (_username == 'etudiant' && _password == '1234') {
            success = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CommonHomepage(
                  userType: _selectedType,
                  userName: _username,
                  userFirstName: 'Etudiant',
                  userClass: 'ClasseExemple',
                ),
              ),
            );
          } else {
            success = false;
          }
          break;
        case 'Parent':
          // TODO: Replace with real login logic and fetch user data
          if (_username == 'parent' && _password == '1234') {
            success = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CommonHomepage(
                  userType: _selectedType,
                  userName: _username,
                  userFirstName: 'Parent',
                  userClass: '',
                ),
              ),
            );
          } else {
            success = false;
          }
          break;
        case 'Coordinateur':
          // TODO: Replace with real login logic and fetch user data
          if (_username == 'coord' && _password == '1234') {
            success = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CommonHomepage(
                  userType: _selectedType,
                  userName: _username,
                  userFirstName: 'Coordinateur',
                  userClass: '',
                ),
              ),
            );
          } else {
            success = false;
          }
          break;
        case 'Enseignant':
          // TODO: Replace with real login logic and fetch user data
          if (_username == 'enseignant' && _password == '1234') {
            success = true;
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => CommonHomepage(
                  userType: _selectedType,
                  userName: _username,
                  userFirstName: 'Enseignant',
                  userClass: '',
                ),
              ),
            );
          } else {
            success = false;
          }
          break;
      }
    } catch (e) {
      success = false;
    }
    setState(() => _isLoading = false);
    if (success) {
      // Naviguer vers l'interface correspondante
      Navigator.of(context).pushReplacementNamed('/next_screen');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur de connexion')),
      );
    }
  }
}
import 'package:flutter/material.dart';
import 'package:ifran/screens/common_homepage.dart';
import 'package:ifran/helpers/users_helper.dart';
import 'package:ifran/helpers/eleves_helper.dart';
import 'package:ifran/helpers/parent_helper.dart';

// Écran de connexion pour l'application
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// État de l'écran de connexion
class _LoginScreenState extends State<LoginScreen> {
  // Clé pour le formulaire
  final _formKey = GlobalKey<FormState>();
  // Variables pour stocker les valeurs du formulaire
  String _email = '';
  String _password = '';
  String _selectedType = 'Etudiant';
  bool _isLoading = false;

  // Liste des types d'utilisateurs disponibles
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
                            labelText: 'Email',
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
                              return 'Veuillez entrer un email';
                            }
                            final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                            if (!emailRegex.hasMatch(value)) {
                              return 'Veuillez entrer un email valide';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
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
                            if (value.length < 6) {
                              return 'Le mot de passe doit contenir au moins 6 caractères';
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
    FocusScope.of(context).unfocus();
    setState(() => _isLoading = true);

    try {
      if (_selectedType == 'Etudiant') {
        final eleve = await ElevesHelper.loginEleve(_email, _password);
        if (eleve != null) {
          // Login successful, navigate to common homepage
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CommonHomepage(
                userType: _selectedType,
                userName: eleve.nom,
                userFirstName: eleve.prenom,
                userClass: eleve.classeId != null ? 'Classe ${eleve.classeId}' : '',
                userNiveau: eleve.classe?.niveau ?? 'niveau',
                userSpecialite: eleve.classe?.specialite ?? 'specialite',
                classId: eleve.classeId,
                userData: eleve,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Identifiants incorrects')),
          );
        }
      } else if (_selectedType == 'Parent') {
        final parent = await ParentHelper.loginParent(_email, _password);
        if (parent != null) {
          // Login successful, derive data from first child if available (niveau/specialite not applicable to parents)
          String userClass = '';
          if (parent.children != null && parent.children!.isNotEmpty) {
            final firstChild = parent.children!.first;
            userClass = firstChild.classeId != null ? 'Classe ${firstChild.classeId}' : '';
          }
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CommonHomepage(
                userType: _selectedType,
                userName: parent.nom,
                userFirstName: parent.prenom,
                userClass: userClass,
                userData: parent,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Identifiants incorrects')),
          );
        }
      } else {
        final user = await UsersHelper.loginByType(_selectedType, _email, _password);
        if (user != null) {
          // Login successful, navigate to homepage with user data
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => CommonHomepage(
                userType: _selectedType,
                userName: user.nom,
                userFirstName: user.prenom,
                userClass: user.classeId != null ? 'Classe ${user.classeId}' : '',
                userData: user,
              ),
            ),
          );
        } else {
          // Login failed
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Identifiants incorrects')),
          );
        }
      }
    } catch (e) {
      // Handle network or other errors
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur de connexion: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
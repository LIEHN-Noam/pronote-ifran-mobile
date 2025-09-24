import 'package:flutter/material.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
      body: SingleChildScrollView(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/login_background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 300,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Image.asset('assets/images/admin.png',
                            height: 50), // Ajout de l'image
                        const SizedBox(height: 10),
                        const Text(
                          'Espace Admin',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Identifiant',
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold, // Mettre en gras
                                    color: Colors.grey, // Couleur grise
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Arrondir les angles
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true, // Ajout de cette propriété
                                  fillColor: const Color.fromRGBO(212, 236, 252, 1.0),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez entrer un nom d\'utilisateur';
                                  }
                                  return null;
                                },
                                onSaved: (value) => _username = value!,
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Mot de passe',
                                  labelStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.bold, // Mettre en gras
                                    color: Colors.grey, // Couleur grise
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(
                                        10), // Arrondir les angles
                                    borderSide: BorderSide.none,
                                  ),
                                  filled: true, // Ajout de cette propriété
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
                              ElevatedButton(
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    // Traitement du formulaire ici
                                    print(
                                        'Nom d\'utilisateur: $_username, Mot de passe: $_password');
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red, // Couleur du bouton
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(double.infinity,
                                      40), // Définit la largeur et la hauteur du bouton
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

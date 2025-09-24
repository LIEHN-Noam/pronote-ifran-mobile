import 'package:flutter/material.dart';
import 'package:ifran/helpers/users_helper.dart';

class CoordLogin extends StatefulWidget {
  const CoordLogin({super.key});

  @override
  State<CoordLogin> createState() => _CoordLoginState();
}

class _CoordLoginState extends State<CoordLogin> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
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
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/login_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: LayoutBuilder(
          builder: (context, constraints) {
            return ConstrainedBox(
                constraints: BoxConstraints(maxHeight: constraints.maxHeight),
                child: SingleChildScrollView(
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
                              Image.asset('assets/images/coordinateur.png',
                                  height: 50), // Ajout de l'image
                              const SizedBox(height: 10),
                              const Text(
                                'Espace Coordinateur',
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
                                        filled:
                                            true, // Ajout de cette propriété
                                        fillColor:
                                            const Color.fromRGBO(212, 236, 252, 1.0),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Veuillez entrer un nom d\'utilisateur';
                                        }
                                        return null;
                                      },
                                      onSaved: (value) => _email = value!,
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
                                        filled:
                                            true, // Ajout de cette propriété
                                        fillColor:
                                            const Color.fromRGBO(212, 236, 252, 1.0),
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
                                      onPressed: () async {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                          final user =
                                              await UsersHelper.loginUser(
                                                  _email, _password);
                                          if (user != null) {
                                            // Login successful, navigate to the next screen or perform any other action
                                            Navigator.of(context)
                                                .pushReplacementNamed(
                                                    '/next_screen');
                                          } else {
                                            // Login failed, show an error message or perform any other action
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                  content: Text(
                                                      'Erreur de connexion')),
                                            );
                                          }
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
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ));
          },
        )),
      ),
    );
  }
}

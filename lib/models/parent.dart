import 'package:ifran/models/eleve.dart';

// Classe représentant un parent avec ses informations et ses enfants
class Parent{
  // Identifiant unique du parent
  int? id;
  // Nom de famille du parent
  String nom;
  // Prénom du parent
  String prenom;
  // Adresse email du parent
  String email;
  // Mot de passe du parent
  String password;
  // Liste des enfants associés au parent
  List<Eleve>? children;

  // Constructeur pour créer un nouveau parent
  Parent({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    this.children,
  });

  // Factory pour créer un parent à partir d'une map JSON
  factory Parent.fromMap(Map<String, dynamic> json) => Parent(
    id: json['id'],
    nom: json['nom'] ?? '',
    prenom: json['prenom'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    children: json['children'] != null ? (json['children'] as List).map((e) => Eleve.fromMap(e as Map<String, dynamic>)).toList() : null,
  );

  // Méthode pour convertir le parent en map pour la base de données
  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'password': password,
    'children': children?.map((e) => e.toMap()).toList(),
  };

  // Méthode pour définir la liste des enfants
  void setChildren(List<Eleve> childs) {
    children = childs;
  }
}

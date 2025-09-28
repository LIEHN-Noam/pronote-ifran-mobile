import 'package:ifran/models/classes.dart';
import 'package:ifran/models/parent.dart';

// Classe représentant un élève avec ses informations personnelles et relations
class Eleve {
  // Identifiant unique de l'élève
  int? id;
  // Nom de famille de l'élève
  String nom;
  // Prénom de l'élève
  String prenom;
  // Adresse email de l'élève
  String email;
  // Mot de passe de l'élève
  String password;
  // Identifiant de la classe de l'élève
  int classeId;
  // Identifiant du parent de l'élève
  int parentId;
  // Objet classe associé (optionnel, chargé depuis la base)
  Classes? classe;
  // Objet parent associé (optionnel, chargé depuis la base)
  Parent? parent;

  // Constructeur pour créer un nouvel élève
  Eleve({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.classeId,
    required this.parentId,
    this.classe,
    this.parent,
  });

  // Factory pour créer un élève à partir d'une map JSON
  factory Eleve.fromMap(Map<String, dynamic> json) => Eleve(
    id: json["id"],
    nom: json["nom"] ?? '',
    prenom: json["prenom"] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    classeId: json['classe_id'] ?? 0,
    parentId: json['parent_id'] ?? 0,
    classe: json['classe'] != null ? Classes.fromMap(json['classe']) : null,
    parent: json['parent'] != null ? Parent.fromMap(json['parent']) : null,
  );

  // Méthode pour convertir l'élève en map pour la base de données
  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom' : prenom,
    'email': email,
    'password' : password,
    'classe_id' : classeId,
    'parent_id' : parentId,
    if (classe != null) 'classe': classe!.toMap(),
    if (parent != null) 'parent': parent!.toMap(),
  };
}

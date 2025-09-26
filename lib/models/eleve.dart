import 'package:ifran/models/classes.dart';
import 'package:ifran/models/parent.dart';

class Eleve {
  int? id;
  String nom;
  String prenom;
  String email;
  String password;
  int classeId;
  int parentId;
  Classes? classe;
  Parent? parent;

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
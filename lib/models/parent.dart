import 'package:ifran/models/eleve.dart';

class Parent{
  int? id;
  String nom;
  String prenom;
  String email;
  String password;
  List<Eleve>? children;

  Parent({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    this.children,
  });

  factory Parent.fromMap(Map<String, dynamic> json) => Parent(
    id: json['id'],
    nom: json['nom'] ?? '',
    prenom: json['prenom'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
    children: json['children'] != null ? (json['children'] as List).map((e) => Eleve.fromMap(e as Map<String, dynamic>)).toList() : null,
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'password': password,
    'children': children?.map((e) => e.toMap()).toList(),
  };

  void setChildren(List<Eleve> childs) {
    children = childs;
  }
}

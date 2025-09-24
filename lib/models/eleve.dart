class Eleve {
  int? id;
  String nom;
  String prenom;
  String email;
  String password;
  int classeId;
  int parentId;

  Eleve({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.classeId,
    required this.parentId,
  });
  factory Eleve.fromMap(Map<String, dynamic> json) => Eleve(
    id: json["id"],
    nom: json["nom"],
    prenom: json["prenom"],
    email: json['email'],
    password: json['password'],
    classeId: json['classeId'],
    parentId: json['parentId'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom' : prenom,
    'email': email,
    'password' : password,
    'classeId' : classeId,
    'parentId' : parentId,
  };
}
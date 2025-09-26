class Users {
  int? id;
  String nom;
  String prenom;
  String email;
  String password;
  String role;
  int? classeId;
  int? parentId;

  Users({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password,
    required this.role,
    this.classeId,
    this.parentId,
  });
  factory Users.fromMap(Map<String, dynamic> json) => Users(
    id: json["id"],
    nom: json["nom"],
    prenom: json["prenom"],
    email: json['email'],
    password: json['password'],
    role: json['role'],
    classeId: json['classe_id'],
    parentId: json['parent_id'],
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom' : prenom,
    'email': email,
    'password' : password,
    'role' : role,
    if (classeId != null) 'classe_id': classeId,
    if (parentId != null) 'parent_id': parentId,
  };
}
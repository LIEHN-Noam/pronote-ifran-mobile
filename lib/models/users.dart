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
  factory Users.fromMap(Map<String, dynamic> json) {
    final user = Users(
      id: json["id"],
      nom: json["nom"],
      prenom: json["prenom"],
      email: json['email'],
      password: json['password'],
      role: json['role'],
      classeId: json['classe_id'],
      parentId: json['parent_id'],
    );
    // Restrict classeId to students only
    if (user.role != 'eleves') {
      user.classeId = null;
    }
    return user;
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom' : prenom,
    'email': email,
    'password' : password,
    'role' : role,
    if (role == 'eleves' && classeId != null) 'classe_id': classeId,
    if (parentId != null) 'parent_id': parentId,
  };
}
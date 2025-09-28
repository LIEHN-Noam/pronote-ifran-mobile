class Users {
  // Identifiant unique de l'utilisateur
  int? id;
  // Nom de famille de l'utilisateur
  String nom;
  // Prénom de l'utilisateur
  String prenom;
  // Adresse email de l'utilisateur
  String email;
  // Mot de passe de l'utilisateur
  String password;
  // Rôle de l'utilisateur (eleves, parent, etc.)
  String role;
  // Identifiant de la classe (pour les élèves seulement)
  int? classeId;
  // Identifiant du parent (pour les élèves seulement)
  int? parentId;

  // Constructeur pour créer un nouvel utilisateur
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

  // Factory pour créer un utilisateur à partir d'une map JSON provenant de la base de données
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
    // Restreindre classeId aux élèves seulement
    if (user.role != 'eleves') {
      user.classeId = null;
    }
    return user;
  }

  // Méthode pour convertir l'utilisateur en map pour l'insertion ou la mise à jour en base de données
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

class Parent{
  int? id;
  String nom;
  String prenom;
  String email;
  String password;

  Parent({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.password
  });

  factory Parent.fromMap(Map<String, dynamic> json) => Parent(
    id: json['id'],
    nom: json['nom'] ?? '',
    prenom: json['prenom'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'nom': nom,
    'prenom': prenom,
    'email': email,
    'password': password,
  };
}
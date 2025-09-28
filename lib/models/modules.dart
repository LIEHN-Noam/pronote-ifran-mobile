// Classe représentant un module d'enseignement
class Module{
  // Identifiant unique du module
  int? id;
  // Nom ou identifiant numérique du module
  int nom;

  // Constructeur pour créer un nouveau module
  Module({
    this.id,
    required this.nom,
  });

  // Factory pour créer un module à partir d'un JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nom: json['nom'],
    );
  }

  // Méthode pour convertir le module en JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}

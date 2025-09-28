// Classe représentant une classe scolaire avec son niveau et spécialité
class Classes{
  // Identifiant unique de la classe
  int? id;
  // Niveau de la classe (ex: Terminale, Première)
  String niveau;
  // Spécialité de la classe (ex: Mathématiques, Littéraire)
  String specialite;

  // Constructeur pour créer une nouvelle classe
  Classes({
    this.id,
    required this.niveau,
    required this.specialite,
  });

  // Factory pour créer une classe à partir d'une map JSON
  factory Classes.fromMap(Map<String, dynamic> json) => Classes(
    id: json['id'],
    niveau: json['niveau'] ?? '',
    specialite: json['specialite'] ?? '',
  );

  // Méthode pour convertir la classe en map pour la base de données
  Map<String, dynamic> toMap() => {
    'id': id,
    'niveau': niveau,
    'specialite': specialite,
  };
}

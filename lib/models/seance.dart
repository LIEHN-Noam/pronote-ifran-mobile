// Classe représentant un module d'enseignement
class Module {
  // Identifiant unique du module
  final int id;
  // Nom du module
  final String nom;

  // Constructeur pour créer un module
  Module({required this.id, required this.nom});

  // Factory pour créer un module à partir d'un JSON
  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nom: json['nom'],
    );
  }
}

// Classe représentant un enseignant
class Enseignant {
  // Identifiant unique de l'enseignant
  final int id;
  // Nom de famille de l'enseignant
  final String nom;
  // Prénom de l'enseignant
  final String prenom;

  // Constructeur pour créer un enseignant
  Enseignant({required this.id, required this.nom, required this.prenom});

  // Factory pour créer un enseignant à partir d'un JSON
  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }
}

// Classe représentant une classe scolaire
class Classe {
  // Identifiant unique de la classe
  final int id;
  // Niveau de la classe
  final String niveau;
  // Spécialité de la classe
  final String specialite;

  // Constructeur pour créer une classe
  Classe({
    required this.id,
    required this.niveau,
    required this.specialite,
  });

  // Factory pour créer une classe à partir d'un JSON
  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      id: json['id'],
      niveau: json['niveau'],
      specialite: json['specialite'],
    );
  }
}

// Classe représentant une séance de cours
class Seance {
  // Identifiant unique de la séance
  final int id;
  // Date de la séance
  final String date;
  // Période de la séance (matinée, après-midi)
  final String periode;
  // Module enseigné lors de la séance
  final Module module;
  // Enseignant de la séance
  final Enseignant enseignant;
  // Classe concernée par la séance
  final Classe classe;

  // Constructeur pour créer une séance
  Seance({
    required this.id,
    required this.date,
    required this.periode,
    required this.module,
    required this.enseignant,
    required this.classe,
  });

  // Factory pour créer une séance à partir d'un JSON
  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
      id: json['id'],
      date: json['date'],
      periode: json['periode'],
      module: Module.fromJson(json['module']),
      enseignant: Enseignant.fromJson(json['enseignant']),
      classe: Classe.fromJson(json['classe']),
    );
  }
}

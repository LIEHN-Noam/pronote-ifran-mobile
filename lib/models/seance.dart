class Module {
  final int id;
  final String nom;

  Module({required this.id, required this.nom});

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nom: json['nom'],
    );
  }
}

class Enseignant {
  final int id;
  final String nom;
  final String prenom;

  Enseignant({required this.id, required this.nom, required this.prenom});

  factory Enseignant.fromJson(Map<String, dynamic> json) {
    return Enseignant(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
    );
  }
}

class Classe {
  final int id;
  final String niveau;
  final String specialite;

  Classe({
    required this.id,
    required this.niveau,
    required this.specialite,
  });

  factory Classe.fromJson(Map<String, dynamic> json) {
    return Classe(
      id: json['id'],
      niveau: json['niveau'],
      specialite: json['specialite'],
    );
  }
}

class Seance {
  final int id;
  final String date;
  final String periode;
  final Module module;
  final Enseignant enseignant;
  final Classe classe;

  Seance({
    required this.id,
    required this.date,
    required this.periode,
    required this.module,
    required this.enseignant,
    required this.classe,
  });

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

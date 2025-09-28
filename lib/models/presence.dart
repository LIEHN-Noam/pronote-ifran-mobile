
// Classe représentant la présence d'un élève à une séance
class Presence{
  // Identifiant unique de la présence
  int? id;
  // Identifiant de la séance
  int seanceId;
  // Identifiant de l'élève
  int eleveId;
  // Statut de présence (présent, absent, etc.)
  String status;

  // Constructeur pour créer une nouvelle présence
  Presence({
    this.id,
    required this.seanceId,
    required this.eleveId,
    required this.status
  });
}

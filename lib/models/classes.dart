class Classes{
  int? id;
  String niveau;
  String specialite;

  Classes({
    this.id,
    required this.niveau,
    required this.specialite,
  });

  factory Classes.fromMap(Map<String, dynamic> json) => Classes(
    id: json['id'],
    niveau: json['niveau'] ?? '',
    specialite: json['specialite'] ?? '',
  );

  Map<String, dynamic> toMap() => {
    'id': id,
    'niveau': niveau,
    'specialite': specialite,
  };
}
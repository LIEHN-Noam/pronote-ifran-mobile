class Module{
  int? id;
  int nom;

  Module({
    this.id,
    required this.nom,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    return Module(
      id: json['id'],
      nom: json['nom'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
    };
  }
}

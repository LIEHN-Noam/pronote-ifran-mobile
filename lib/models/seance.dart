class Seance{
  int? id;
  int classeId;
  int enseignantId;
  DateTime date;
  String periode;
  String moduleId;
  

  Seance({
    this.id,
    required this.classeId,
    required this.enseignantId,
    required this.date,
    required this.periode,
    required this.moduleId,
  });
}
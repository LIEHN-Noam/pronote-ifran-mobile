import 'package:flutter/material.dart';
import 'package:ifran/models/seance.dart';
import 'package:ifran/models/eleve.dart';
import 'package:ifran/models/classes.dart';
import 'package:ifran/services/api_service.dart';
import 'package:ifran/helpers/users_helper.dart';

// Page pour afficher l'emploi du temps d'un enfant depuis le compte parent
class ParentChildSchedulePage extends StatefulWidget {
  // Nom du parent
  final String parentName;
  // Prénom du parent
  final String parentFirstName;
  // ID du parent
  final int? parentId;
  // Enfant sélectionné
  final Eleve selectedChild;

  const ParentChildSchedulePage({
    super.key,
    required this.parentName,
    required this.parentFirstName,
    this.parentId,
    required this.selectedChild,
  });

  @override
  State<ParentChildSchedulePage> createState() => _ParentChildSchedulePageState();
}

// État de la page d'emploi du temps de l'enfant
class _ParentChildSchedulePageState extends State<ParentChildSchedulePage> {
  // Future pour récupérer les séances
  late Future<List<Seance>> futureSeances;

  @override
  void initState() {
    super.initState();
    futureSeances = ApiService().fetchSeances();
  }

  @override
  Widget build(BuildContext context) {
    final childClasse = widget.selectedChild.classe;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 0, 102, 1.0),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Emploi du Temps - ${widget.selectedChild.prenom} ${widget.selectedChild.nom}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.logout, color: Colors.white, size: 20),
            ),
            onPressed: () async {
              await UsersHelper.logout();
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Emploi du temps de ${widget.selectedChild.prenom} ${widget.selectedChild.nom}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          if (childClasse != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Classe: ${childClasse.niveau} ${childClasse.specialite}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Expanded(
            child: FutureBuilder<List<Seance>>(
              future: futureSeances,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Erreur : ${snapshot.error}",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "Aucune séance trouvée",
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final seances = snapshot.data!;
                final filteredSeances = widget.selectedChild.classeId != null 
                    ? seances.where((s) => s.classe.id == widget.selectedChild.classeId).toList() 
                    : seances;
                Map<String, List<Seance>> groupedSeances = {};
                for (var seance in filteredSeances) {
                  groupedSeances[seance.date] ??= [];
                  groupedSeances[seance.date]!.add(seance);
                }
                var filteredGrouped = Map.fromEntries(
                  groupedSeances.entries.where((e) => DateTime.parse(e.key).isAfter(DateTime.now().subtract(const Duration(days: 1))))
                );
                var sortedEntries = filteredGrouped.entries.toList()
                  ..sort((a, b) => b.key.compareTo(a.key));
                sortedEntries = sortedEntries.take(10).toList();
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    children: sortedEntries.map((entry) {
                      String date = entry.key;
                      List<Seance> daySeances = entry.value;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12.0),
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(2, 0, 102, 0.1),
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Text(
                              'Date: $date',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(2, 0, 102, 1.0),
                              ),
                            ),
                          ),
                          ...daySeances.map((s) => Card(
                            margin: const EdgeInsets.all(8),
                            elevation: 4,
                            color: Colors.blue.shade50,
                            child: ListTile(
                              leading: const Icon(Icons.schedule, color: Colors.blue),
                              title: Text(
                                "${s.module.nom} - ${s.periode}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue.shade900,
                                ),
                              ),
                              subtitle: Text(
                                "Prof: ${s.enseignant.nom} ${s.enseignant.prenom}\n"
                                "Classe: ${s.classe.niveau} ${s.classe.specialite}",
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                              isThreeLine: true,
                            ),
                          )),
                        ],
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

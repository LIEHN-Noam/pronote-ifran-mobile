import 'package:flutter/material.dart';
import 'package:ifran/models/seance.dart';
import 'package:ifran/services/api_service.dart';
import 'package:ifran/helpers/users_helper.dart';

// Page pour afficher l'emploi du temps des étudiants
class SeancesPage extends StatefulWidget {
  // Type d'utilisateur
  final String userType;
  // Nom de l'utilisateur
  final String userName;
  // Prénom de l'utilisateur
  final String userFirstName;
  // Niveau de l'utilisateur
  final String userNiveau;
  // Spécialité de l'utilisateur
  final String userSpecialite;
  // ID de la classe
  final int? classId;

  const SeancesPage({
    super.key,
    required this.userType,
    required this.userName,
    required this.userFirstName,
    required this.userNiveau,
    required this.userSpecialite,
    this.classId,
  });

  @override
  State<SeancesPage> createState() => _SeancesPageState();
}

// État de la page d'emploi du temps
class _SeancesPageState extends State<SeancesPage> {
  // Future pour récupérer les séances
  late Future<List<Seance>> futureSeances;

  @override
  void initState() {
    super.initState();
    futureSeances = ApiService().fetchSeances();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(2, 0, 102, 1.0),
        iconTheme: IconThemeData(color: Colors.white),
        centerTitle: true,
        title: Text(
          'Emploi du Temps',
          style: TextStyle(
            fontSize: 24,
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
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(2, 0, 102, 1.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.userName} ${widget.userFirstName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${widget.userType}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Classe: ${widget.userNiveau} ${widget.userSpecialite}',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              tileColor: Colors.grey.shade200,
              leading: const Icon(Icons.schedule, color: Colors.blue),
              title: const Text('Emploi du temps'),
              onTap: () {
                Navigator.pop(context); // Close drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.grade, color: Colors.green),
              title: const Text('Notes'),
              onTap: () {
                Navigator.pop(context);
                // Naviguer vers la page notes
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                'Votre emploi du temps',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final seances = snapshot.data!;
                final filteredSeances = widget.classId != null ? seances.where((s) => s.classe.id == widget.classId).toList() : seances;
                Map<String, List<Seance>> groupedSeances = {};
                for (var seance in filteredSeances) {
                  groupedSeances[seance.date] ??= [];
                  groupedSeances[seance.date]!.add(seance);
                }
                var filteredGrouped = Map.fromEntries(groupedSeances.entries.where((e) => DateTime.parse(e.key).isAfter(DateTime.now().subtract(Duration(days: 1)))));
                var sortedEntries = filteredGrouped.entries.toList()..sort((a, b) => b.key.compareTo(a.key));
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
                            color: Color.fromRGBO(2, 0, 102, 0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            'Date: $date',
                            style: TextStyle(
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
                              leading: Icon(Icons.schedule, color: Colors.blue),
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
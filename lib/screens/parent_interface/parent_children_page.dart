import 'package:flutter/material.dart';
import 'package:ifran/models/eleve.dart';
import 'package:ifran/models/classes.dart';
import 'package:ifran/models/parent.dart';
import 'package:ifran/screens/parent_interface/parent_child_schedule_page.dart';
import 'package:ifran/helpers/users_helper.dart';

// Page pour afficher les enfants d'un parent
class ParentChildrenPage extends StatelessWidget {
  // Liste des enfants
  final List<Eleve> children;
  // Objet parent
  final Parent parent;

  const ParentChildrenPage({
    super.key,
    required this.children,
    required this.parent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 0, 102, 1.0),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Mes Enfants',
          style: TextStyle(
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
      body: children.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.child_care,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Aucun enfant lié.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: children.length,
              itemBuilder: (context, index) {
                final eleve = children[index];
                final classe = eleve.classe;
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.purple,
                      child: Text(
                        '${eleve.prenom[0]}${eleve.nom[0]}'.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      '${eleve.prenom} ${eleve.nom}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (classe != null) ...[
                          Text(
                            'Classe: ${classe.niveau} ${classe.specialite}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 4),
                        ],
                        Text(
                          'Email: ${eleve.email}',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      // Navigate to child's schedule with parent sidebar
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ParentChildSchedulePage(
                            parentName: parent.nom,
                            parentFirstName: parent.prenom,
                            parentId: parent.id,
                            selectedChild: eleve,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

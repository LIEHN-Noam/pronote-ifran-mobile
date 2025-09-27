 import 'package:flutter/material.dart';
import 'package:ifran/helpers/users_helper.dart';
import 'package:ifran/screens/student_interface/student_schedule_page.dart';

class CommonHomepage extends StatelessWidget {
  final String userType;
  final String userName;
  final String userFirstName;
  final String userClass;
  final String userNiveau;
  final String userSpecialite;
  final int? classId;

  const CommonHomepage({
    super.key,
    required this.userType,
    this.userFirstName = 'Prénom',
    this.userName = 'Utilisateur',
    this.userClass = 'Classe',
    this.userNiveau = 'Niveau',
    this.userSpecialite = 'Spécialite',
    this.classId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(2, 0, 102, 1.0),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Accueil $userType',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
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
                    '$userName $userFirstName',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '$userType',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 5),
                  if (userType == 'Etudiant') ...[
                    Text(
                      'Classe: $userNiveau $userSpecialite',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 5),
                  ],
                  
                ],
              ),
            ),
            ..._getDrawerOptionsForUserType(context),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bienvenue, $userName $userFirstName',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (userType == 'Etudiant') ...[
                    const SizedBox(height: 8),
                    Text(
                      'Classe: $userNiveau $userSpecialite',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            ..._getBodyButtonsForUserType(context),
            const SizedBox(height: 20),
            const Text(
              'Utilisez le menu pour accéder aux options.',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Déconnexion'),
              onPressed: () async {
                await UsersHelper.logout();
                Navigator.of(context).pushReplacementNamed('/');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                minimumSize: const Size(200, 40),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getDrawerOptionsForUserType(BuildContext context) {
    switch (userType) {
      case 'Etudiant':
        return [
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.blue),
            title: const Text('Emploi du temps'),
            onTap: () {
              Navigator.pop(context); // Close drawer
              if (classId != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SeancesPage(
                    userType: userType,
                    userName: userName,
                    userFirstName: userFirstName,
                    userNiveau: userNiveau,
                    userSpecialite: userSpecialite,
                    classId: classId,
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Classe non associée.')),
                );
              }
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
        ];
      case 'Parent':
        return [
          ListTile(
            leading: const Icon(Icons.child_care, color: Colors.purple),
            title: const Text('Informations Enfant'),
            onTap: () {
              Navigator.pop(context);
              // Naviguer vers la page informations enfant
            },
          ),
        ];
      case 'Coordinateur':
        return [
          ListTile(
            leading: const Icon(Icons.admin_panel_settings, color: Colors.teal),
            title: const Text('Gestion Utilisateurs'),
            onTap: () {
              Navigator.pop(context);
              // Naviguer vers la page gestion utilisateurs
            },
          ),
          ListTile(
            leading: const Icon(Icons.schedule, color: Colors.blue),
            title: const Text('Emploi du temps'),
            onTap: () {
              Navigator.pop(context);
              // Naviguer vers la page emploi du temps
            },
          ),
        ];
      case 'Enseignant':
        return [
          ListTile(
            leading: const Icon(Icons.class_, color: Colors.indigo),
            title: const Text('Gestion Classes'),
            onTap: () {
              Navigator.pop(context);
              // Naviguer vers la page gestion classes
            },
          ),
          ListTile(
            leading: const Icon(Icons.grade, color: Colors.green),
            title: const Text('Notes Élèves'),
            onTap: () {
              Navigator.pop(context);
              // Naviguer vers la page notes élèves
            },
          ),
        ];
      default:
        return [
          const ListTile(
            title: Text('Type d\'utilisateur non reconnu.'),
          ),
        ];
    }
  }

  List<Widget> _getBodyButtonsForUserType(BuildContext context) {
    switch (userType) {
      case 'Etudiant':
        return [
          ElevatedButton.icon(
            icon: const Icon(Icons.schedule, color: Colors.white),
            label: const Text('Emploi du temps'),
            onPressed: () {
              if (classId != null) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SeancesPage(
                    userType: userType,
                    userName: userName,
                    userFirstName: userFirstName,
                    userNiveau: userNiveau,
                    userSpecialite: userSpecialite,
                    classId: classId,
                  ),
                ));
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Classe non associée.')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.grade, color: Colors.white),
            label: const Text('Notes'),
            onPressed: () {
              // Naviguer vers la page notes
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ];
      case 'Parent':
        return [
          ElevatedButton.icon(
            icon: const Icon(Icons.child_care, color: Colors.white),
            label: const Text('Informations Enfant'),
            onPressed: () {
              // Naviguer vers la page informations enfant
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.purple,
              foregroundColor: Colors.white,
            ),
          ),
        ];
      case 'Coordinateur':
        return [
          ElevatedButton.icon(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.white),
            label: const Text('Gestion Utilisateurs'),
            onPressed: () {
              // Naviguer vers la page gestion utilisateurs
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.schedule, color: Colors.white),
            label: const Text('Emploi du temps'),
            onPressed: () {
              // Naviguer vers la page emploi du temps
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
          ),
        ];
      case 'Enseignant':
        return [
          ElevatedButton.icon(
            icon: const Icon(Icons.class_, color: Colors.white),
            label: const Text('Gestion Classes'),
            onPressed: () {
              // Naviguer vers la page gestion classes
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo,
              foregroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton.icon(
            icon: const Icon(Icons.grade, color: Colors.white),
            label: const Text('Notes Élèves'),
            onPressed: () {
              // Naviguer vers la page notes élèves
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
            ),
          ),
        ];
      default:
        return [
          const Text('Type d\'utilisateur non reconnu.'),
        ];
    }
  }
}

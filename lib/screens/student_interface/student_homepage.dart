// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:ifran/helpers/users_helper.dart';

// Page d'accueil pour les élèves
class StudentHomepage extends StatelessWidget {
	// Type d'utilisateur
	final String userType;
	// Nom de l'utilisateur
	final String userName;
	// Prénom de l'utilisateur
	final String userFirstName;
	// Classe de l'utilisateur
	final String userClass;
	const StudentHomepage({
		super.key,
		required this.userType,
		required this.userName,
		required this.userFirstName,
		required this.userClass,
	});

	@override
	Widget build(BuildContext context) {
					return Scaffold(
						appBar: AppBar(
							backgroundColor: Color.fromRGBO(2, 0, 102, 1.0),
							centerTitle: true,
							title: Text(
								'Accueil Élève',
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
						body: SingleChildScrollView(
							child: Center(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
														Text(
															'Bienvenue, $userFirstName $userName - $userClass',
															style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
														),
														SizedBox(height: 30),
										SizedBox(height: 30),
										ElevatedButton.icon(
											icon: Icon(Icons.schedule),
											label: Text('Emploi du temps'),
											onPressed: () {
												// Naviguer vers la page emploi du temps
											},
											style: ElevatedButton.styleFrom(
												backgroundColor: Colors.blue,
												foregroundColor: Colors.white,
												minimumSize: Size(200, 40),
											),
										),
										SizedBox(height: 20),
										ElevatedButton.icon(
											icon: Icon(Icons.grade),
											label: Text('Notes'),
											onPressed: () {
												// Naviguer vers la page notes
											},
											style: ElevatedButton.styleFrom(
												backgroundColor: Colors.green,
												foregroundColor: Colors.white,
												minimumSize: Size(200, 40),
											),
										),

									],  
								),
							),
						),
					);
	}
}

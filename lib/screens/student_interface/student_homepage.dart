// import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class StudentHomepage extends StatelessWidget {
	final String studentName;
	const StudentHomepage({super.key, this.studentName = 'Nom Élève'});

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
						),
						body: SingleChildScrollView(
							child: Center(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
														Text(
															'Bienvenue, $studentName',
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
										SizedBox(height: 20),
										ElevatedButton.icon(
											icon: Icon(Icons.message),
											label: Text('Messagerie'),
											onPressed: () {
												// Naviguer vers la page messagerie
											},
											style: ElevatedButton.styleFrom(
												backgroundColor: Colors.orange,
												foregroundColor: Colors.white,
												minimumSize: Size(200, 40),
											),
										),
										SizedBox(height: 40),
										ElevatedButton.icon(
											icon: Icon(Icons.logout),
											label: Text('Déconnexion'),
											onPressed: () {
												Navigator.of(context).pushReplacementNamed('/');
											},
											style: ElevatedButton.styleFrom(
												backgroundColor: Colors.red,
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

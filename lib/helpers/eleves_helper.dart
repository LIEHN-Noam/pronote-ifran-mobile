import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ifran/models/eleve.dart';
import 'package:ifran/models/classes.dart';
import 'package:ifran/services/api_service.dart';

// Classe utilitaire pour gérer les opérations liées aux élèves via l'API
class ElevesHelper {
  // Méthode pour créer un élève
  static Future<int> createEleve(
      String nom, String prenom, String email, String password) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/eleves'),
        headers: authHeaders,
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['id'] ?? 0;
      } else {
        throw Exception('Échec de la création de l\'élève: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'élève: $e');
    }
  }

  // Méthode pour récupérer tous les élèves
  static Future<List<Eleve>> getAllEleves() async {
    try {
      final response = await ApiService.getAllEleves();
      return response.map((e) => Eleve.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des élèves: $e');
    }
  }

  // Méthode pour récupérer un élève par ID
  static Future<List<Eleve>> getEleve(int id) async {
    try {
      final students = await getAllEleves();
      return students.where((student) => student.id == id).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'élève: $e');
    }
  }

  // Méthode pour récupérer un élève par email
  static Future<Eleve?> getEleveByEmail(String email) async {
    try {
      final data = await ApiService.getEleveByEmail(email);
      if (data != null) {
        return Eleve.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'élève par email: $e');
    }
  }

  // Méthode pour mettre à jour un élève
  static Future<int> updateEleve(
      int id, String nom, String prenom, String email, String password) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/eleves/$id'),
        headers: authHeaders,
        body: jsonEncode({
          'nom': nom,
          'prenom': prenom,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'élève: $e');
    }
  }

  // Méthode pour supprimer un élève
  static Future<void> deleteEleve(int id) async {
    throw Exception('Suppression d\'élève non implémentée dans l\'API');
  }

  // Méthode pour connecter un élève
  static Future<Eleve?> loginEleve(String email, String password) async {
    try {
      final response = await ApiService.studentLogin(email, password);
      if (response['success'] == true) {
        final eleveData = response['student'] as Map<String, dynamic>? ?? {};
        final eleve = Eleve.fromMap(eleveData);
        eleve.password = '';
        if (eleve.classeId != null && eleve.classeId != 0) {
          try {
            final classes = await ApiService.getAllClasses();
            final matchingClasses = classes.where((c) => c['id'] == eleve.classeId);
            if (matchingClasses.isNotEmpty) {
              final classeData = matchingClasses.first;
              eleve.classe = Classes.fromMap(classeData);
            }
          } catch (e) {
          }
        }
        return eleve;
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la connexion élève: $e');
    }
  }
}

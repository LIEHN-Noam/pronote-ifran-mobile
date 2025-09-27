import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ifran/models/eleve.dart';
import 'package:ifran/models/classes.dart';
import 'package:ifran/services/api_service.dart';

// Classe pour gérer les opérations d'élèves via l'API
class ElevesHelper {
  // Créer Eleve
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
        throw Exception('Failed to create eleve: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error creating eleve: $e');
    }
  }

  // Récupération de tout la liste des élèves
  static Future<List<Eleve>> getAllEleves() async {
    try {
      final response = await ApiService.getAllEleves();
      return response.map((e) => Eleve.fromMap(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw Exception('Error fetching eleves: $e');
    }
  }

  // Méthode pour récupérer un élève par son ID
  static Future<List<Eleve>> getEleve(int id) async {
    try {
      final students = await getAllEleves();
      return students.where((student) => student.id == id).toList();
    } catch (e) {
      throw Exception('Error fetching student: $e');
    }
  }

  // Get Eleve by Email
  static Future<Eleve?> getEleveByEmail(String email) async {
    try {
      final data = await ApiService.getEleveByEmail(email);
      if (data != null) {
        return Eleve.fromMap(data);
      }
      return null;
    } catch (e) {
      throw Exception('Error fetching eleve by email: $e');
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
        return 1; // Success
      } else {
        return 0; // Failure
      }
    } catch (e) {
      throw Exception('Error updating eleve: $e');
    }
  }

  // Méthode pour supprimer un élève
  static Future<void> deleteEleve(int id) async {
    // Note: API might not support deletion, so this is a placeholder
    throw Exception('Delete student not implemented in API');
  }

  static Future<Eleve?> loginEleve(String email, String password) async {
    try {
      final response = await ApiService.studentLogin(email, password);
      print('DEBUG: Student login response: $response'); // Log full response for debugging
      if (response['success'] == true) {
        final eleveData = response['student'] as Map<String, dynamic>? ?? {};
        print('DEBUG: Eleve data to parse: $eleveData'); // Log data being parsed
        final eleve = Eleve.fromMap(eleveData);
        eleve.password = ''; // Don't store password post-login for security
        // Fetch classe details if classeId is present (student-specific, as niveau and specialite apply only to students)
        if (eleve.classeId != null && eleve.classeId != 0) {
          try {
            final classes = await ApiService.getAllClasses();
            final matchingClasses = classes.where((c) => c['id'] == eleve.classeId);
            if (matchingClasses.isNotEmpty) {
              final classeData = matchingClasses.first;
              eleve.classe = Classes.fromMap(classeData);
            }
          } catch (e) {
            print('DEBUG: Error fetching classe: $e'); // Log error but don't fail login
          }
        }
        return eleve;
      }
      return null;
    } catch (e) {
      print('DEBUG: Error in loginEleve: $e'); // Log error details
      throw Exception('Error during student login: $e');
    }
  }
}

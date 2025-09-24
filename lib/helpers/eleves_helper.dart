import 'package:ifran/models/eleve.dart';
import 'package:ifran/services/api_service.dart';

// Classe pour gérer les opérations d'élèves via l'API
class ElevesHelper {
  // Créer Eleve
  static Future<int> createEleve(
      String nom, String prenom, String email, String password) async {
    try {
      final response = await ApiService.studentLogin(email, password);
      if (response['success'] == true) {
        return response['user']['id'] ?? 0;
      } else {
        throw Exception('Failed to create student');
      }
    } catch (e) {
      throw Exception('Error creating student: $e');
    }
  }

  // Récupération de tout la liste des élèves
  static Future<List<Map<String, dynamic>>> getAllEleves() async {
    try {
      final response = await ApiService.getParents(); // Assuming students are included in parents list
      return response.map((student) => student as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching students: $e');
    }
  }

  // Méthode pour récupérer un élève par son ID
  static Future<List<Map<String, dynamic>>> getEleve(int id) async {
    try {
      final students = await getAllEleves();
      return students.where((student) => student['id'] == id).toList();
    } catch (e) {
      throw Exception('Error fetching student: $e');
    }
  }

  // Méthode pour mettre à jour un élève
  static Future<int> updateEleve(
      int id, String nom, String prenom, String email, String password) async {
    try {
      final response = await ApiService.studentLogin(email, password);
      if (response['success'] == true) {
        return 1; // Success
      } else {
        return 0; // Failure
      }
    } catch (e) {
      throw Exception('Error updating student: $e');
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
      if (response['success'] == true) {
        final studentData = response['user'];
        return Eleve(
          id: studentData['id'],
          nom: studentData['nom'] ?? '',
          prenom: studentData['prenom'] ?? '',
          email: studentData['email'] ?? '',
          password: studentData['password'] ?? '',
          classeId: studentData['classeId'] ?? 0,
          parentId: studentData['parentId'] ?? 0,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error during student login: $e');
    }
  }
}

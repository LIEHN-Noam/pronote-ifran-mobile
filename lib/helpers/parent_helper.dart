import 'package:ifran/models/parent.dart';
import 'package:ifran/services/api_service.dart';

// Classe pour gérer les opérations de parents via l'API
class ParentHelper {
  // Créer Parent
  static Future<int> createParent(
      String nom, String prenom, String email, String password) async {
    try {
      final response = await ApiService.parentLogin(email, password);
      if (response['success'] == true) {
        return response['user']['id'] ?? 0;
      } else {
        throw Exception('Failed to create parent');
      }
    } catch (e) {
      throw Exception('Error creating parent: $e');
    }
  }

  // Récupération de tout la liste des parents
  static Future<List<Map<String, dynamic>>> getAllParents() async {
    try {
      final response = await ApiService.getParents();
      return response.map((parent) => parent as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching parents: $e');
    }
  }

  // Méthode pour récupérer un parent par son ID
  static Future<List<Map<String, dynamic>>> getParent(int id) async {
    try {
      final parents = await getAllParents();
      return parents.where((parent) => parent['id'] == id).toList();
    } catch (e) {
      throw Exception('Error fetching parent: $e');
    }
  }

  // Méthode pour mettre à jour un parent
  static Future<int> updateParent(
      int id, String nom, String prenom, String email, String password) async {
    try {
      final response = await ApiService.parentLogin(email, password);
      if (response['success'] == true) {
        return 1; // Success
      } else {
        return 0; // Failure
      }
    } catch (e) {
      throw Exception('Error updating parent: $e');
    }
  }

  // Méthode pour supprimer un parent
  static Future<void> deleteParent(int id) async {
    // Note: API might not support deletion, so this is a placeholder
    throw Exception('Delete parent not implemented in API');
  }

  static Future<Parent?> loginParent(String email, String password) async {
    try {
      final response = await ApiService.parentLogin(email, password);
      if (response['success'] == true) {
        final parentData = response['user'];
        return Parent(
          id: parentData['id'],
          nom: parentData['nom'] ?? '',
          prenom: parentData['prenom'] ?? '',
          email: parentData['email'] ?? '',
          password: parentData['password'] ?? '',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error during parent login: $e');
    }
  }
}

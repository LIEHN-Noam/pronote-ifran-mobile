import 'package:ifran/models/users.dart';
import 'package:ifran/services/api_service.dart';

// Classe pour gérer les opérations d'utilisateurs via l'API
class UsersHelper {
  // Créer user
  static Future<int> createUser(String nom, String prenom, String email,
      String password, String role) async {
    try {
      final response = await ApiService.teacherLogin(email, password);
      if (response['success'] == true) {
        return response['user']['id'] ?? 0;
      } else {
        throw Exception('Failed to create user');
      }
    } catch (e) {
      throw Exception('Error creating user: $e');
    }
  }

  // Récupération de tout la liste des utilisateurs
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await ApiService.getParents();
      return response.map((user) => user as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  // Méthode pour récupérer un utilisateur par son ID
  static Future<List<Map<String, dynamic>>> getUser(int id) async {
    try {
      final users = await getAllUsers();
      return users.where((user) => user['id'] == id).toList();
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  // Méthode pour mettre à jour un utilisateur
  static Future<int> updateUser(
      int id, String nom, String prenom, String email, String password) async {
    try {
      final response = await ApiService.teacherLogin(email, password);
      if (response['success'] == true) {
        return 1; // Success
      } else {
        return 0; // Failure
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Méthode pour supprimer un utilisateur
  static Future<void> deleteUser(int id) async {
    // Note: API might not support deletion, so this is a placeholder
    throw Exception('Delete user not implemented in API');
  }

  static Future<Users?> loginUser(String email, String password) async {
    try {
      final response = await ApiService.teacherLogin(email, password);
      if (response['success'] == true) {
        final userData = response['user'];
        return Users(
          id: userData['id'],
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          email: userData['email'] ?? '',
          password: userData['password'] ?? '',
          role: userData['role'] ?? 'teacher',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error during login: $e');
    }
  }
}

import 'package:ifran/models/users.dart';
import 'package:ifran/services/api_service.dart';

// Classe pour gérer les opérations d'utilisateurs via l'API
class UsersHelper {
  // Login for Student
  static Future<Users?> loginAsStudent(String email, String password) async {
    try {
      final response = await ApiService.studentLogin(email, password);
      if (response['success'] == true) {
        final userData = response['user'];
        if (userData == null) {
          throw Exception('User data missing in response');
        }
        return Users(
          id: userData['id'],
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          email: userData['email'] ?? '',
          password: '', // Don't store password
          role: 'eleves',
          classeId: userData['classe_id'] as int?,
          parentId: userData['parent_id'] as int?,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error during student login: $e');
    }
  }

  // Login for Parent
  static Future<Users?> loginAsParent(String email, String password) async {
    try {
      final response = await ApiService.parentLogin(email, password);
      if (response['success'] == true) {
        final userData = response['user'];
        if (userData == null) {
          throw Exception('User data missing in response');
        }
        return Users(
          id: userData['id'],
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          email: userData['email'] ?? '',
          password: '', // Don't store password
          role: 'parent',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error during parent login: $e');
    }
  }

  // Login for Teacher/Coordinator
  static Future<Users?> loginAsTeacher(String email, String password) async {
    try {
      final response = await ApiService.teacherLogin(email, password);
      if (response['success'] == true) {
        final userData = response['user'];
        if (userData == null) {
          throw Exception('User data missing in response');
        }
        return Users(
          id: userData['id'],
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          email: userData['email'] ?? '',
          password: '', // Don't store password
          role: 'teacher',
        );
      }
      return null;
    } catch (e) {
      throw Exception('Error during teacher login: $e');
    }
  }

  // Generic login method based on user type
  static Future<Users?> loginByType(String userType, String email, String password) async {
    switch (userType) {
      case 'Etudiant':
        return await loginAsStudent(email, password);
      case 'Parent':
        return await loginAsParent(email, password);
      case 'Enseignant':
      case 'Coordinateur':
        return await loginAsTeacher(email, password);
      default:
        throw Exception('Unknown user type: $userType');
    }
  }

  // Logout: Clear stored token
  static Future<void> logout() async {
    await ApiService.clearToken();
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }

  // Get current user (if needed, but since no user storage, return null or fetch from API)
  // For now, this is a placeholder; in a full implementation, you might store user data locally
  static Future<Users?> getCurrentUser() async {
    // This would require fetching user data from a protected endpoint using the token
    // For simplicity, return null; implement if backend provides /me endpoint
    return null;
  }

  // Legacy methods (deprecated, but kept for compatibility if needed)
  // Créer user (Note: This was misusing login; proper implementation would need a create endpoint)
  static Future<int> createUser(String nom, String prenom, String email,
      String password, String role) async {
    // TODO: Implement proper create user API call
    throw Exception('Create user not implemented');
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
    // TODO: Implement proper update user API call
    throw Exception('Update user not implemented');
  }

  // Méthode pour supprimer un utilisateur
  static Future<void> deleteUser(int id) async {
    // TODO: Implement proper delete user API call
    throw Exception('Delete user not implemented');
  }

  // Legacy login (deprecated)
  static Future<Users?> loginUser(String email, String password) async {
    return await loginAsTeacher(email, password);
  }
}

import 'package:ifran/models/users.dart';
import 'package:ifran/services/api_service.dart';

// Classe utilitaire pour gérer les opérations liées aux utilisateurs via l'API
class UsersHelper {
  // Méthode pour connecter un étudiant
  static Future<Users?> loginAsStudent(String email, String password) async {
    try {
      final response = await ApiService.studentLogin(email, password);
      if (response['success'] == true) {
        final userData = response['user'];
        if (userData == null) {
          throw Exception('Données utilisateur manquantes dans la réponse');
        }
        final user = Users(
          id: userData['id'],
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          email: userData['email'] ?? '',
          password: '',
          role: 'eleves',
          classeId: userData['classe_id'] as int?,
          parentId: userData['parent_id'] as int?,
        );
        return user;
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la connexion étudiant: $e');
    }
  }

  // Méthode pour connecter un enseignant
  static Future<Users?> loginAsTeacher(String email, String password) async {
    try {
      final response = await ApiService.teacherLogin(email, password);
      if (response['success'] == true) {
        final userData = response['user'];
        if (userData == null) {
          throw Exception('Données utilisateur manquantes dans la réponse');
        }
        return Users(
          id: userData['id'],
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          email: userData['email'] ?? '',
          password: '',
          role: 'teacher',
          classeId: null,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la connexion enseignant: $e');
    }
  }

  // Méthode pour connecter un coordinateur
  static Future<Users?> loginAsCoordinator(String email, String password) async {
    try {
      final response = await ApiService.coordinatorLogin(email, password);
      if (response['success'] == true) {
        var userData = response['user'];
        if (userData == null) {
          throw Exception('Données utilisateur manquantes dans la réponse');
        }
        if ((userData['nom'] == null || userData['nom'].toString().isEmpty) &&
            (userData['prenom'] == null || userData['prenom'].toString().isEmpty)) {
          try {
            final fullUserData = await ApiService.getCoordinatorByEmail(email);
            if (fullUserData != null) {
              userData = fullUserData;
            }
          } catch (fetchError) {
          }
        }
        return Users(
          id: userData['id'],
          nom: userData['nom'] ?? '',
          prenom: userData['prenom'] ?? '',
          email: userData['email'] ?? email,
          password: '',
          role: 'coordinateur',
          classeId: null,
        );
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la connexion coordinateur: $e');
    }
  }

  // Méthode générique de connexion basée sur le type d'utilisateur
  static Future<Users?> loginByType(String userType, String email, String password) async {
    switch (userType) {
      case 'Etudiant':
        return await loginAsStudent(email, password);
      case 'Parent':
        throw UnsupportedError('La connexion parent doit utiliser ParentHelper.loginParent');
      case 'Enseignant':
        return await loginAsTeacher(email, password);
      case 'Coordinateur':
        return await loginAsCoordinator(email, password);
      default:
        throw Exception('Type d\'utilisateur inconnu: $userType');
    }
  }

  // Méthode pour appliquer la restriction classeId aux élèves seulement
  static void enforceStudentOnlyClasseId(Users user) {
    if (user.role != 'eleves') {
      user.classeId = null;
    }
  }

  // Méthode pour déconnecter l'utilisateur
  static Future<void> logout() async {
    await ApiService.clearToken();
  }

  // Méthode pour vérifier si l'utilisateur est connecté
  static Future<bool> isLoggedIn() async {
    final token = await ApiService.getToken();
    return token != null;
  }

  // Méthode pour obtenir l'utilisateur actuel
  static Future<Users?> getCurrentUser() async {
    return null;
  }

  // Méthode pour créer un utilisateur
  static Future<int> createUser(String nom, String prenom, String email,
      String password, String role) async {
    throw Exception('Création d\'utilisateur non implémentée');
  }

  // Méthode pour récupérer tous les utilisateurs
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    try {
      final response = await ApiService.getParents();
      return response.map((user) => user as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des utilisateurs: $e');
    }
  }

  // Méthode pour récupérer un utilisateur par ID
  static Future<List<Map<String, dynamic>>> getUser(int id) async {
    try {
      final users = await getAllUsers();
      return users.where((user) => user['id'] == id).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur: $e');
    }
  }

  // Méthode pour mettre à jour un utilisateur
  static Future<int> updateUser(
      int id, String nom, String prenom, String email, String password) async {
    throw Exception('Mise à jour d\'utilisateur non implémentée');
  }

  // Méthode pour supprimer un utilisateur
  static Future<void> deleteUser(int id) async {
    throw Exception('Suppression d\'utilisateur non implémentée');
  }

  // Méthode de connexion héritée
  static Future<Users?> loginUser(String email, String password) async {
    return await loginAsTeacher(email, password);
  }
}

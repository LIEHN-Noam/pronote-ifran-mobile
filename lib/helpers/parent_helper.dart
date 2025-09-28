import 'package:ifran/models/parent.dart';
import 'package:ifran/models/eleve.dart';
import 'package:ifran/models/classes.dart';
import 'package:ifran/services/api_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// Classe utilitaire pour gérer les opérations liées aux parents via l'API
class ParentHelper {
  // Méthode pour créer un parent
  static Future<int> createParent(
      String nom, String prenom, String email, String password) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.post(
        Uri.parse('${ApiService.baseUrl}/parents'),
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
        throw Exception('Échec de la création du parent: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création du parent: $e');
    }
  }

  // Méthode pour récupérer tous les parents
  static Future<List<Map<String, dynamic>>> getAllParents() async {
    try {
      final response = await ApiService.getParents();
      return response.map((parent) => parent as Map<String, dynamic>).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération des parents: $e');
    }
  }

  // Méthode pour récupérer un parent par ID
  static Future<List<Map<String, dynamic>>> getParent(int id) async {
    try {
      final parents = await getAllParents();
      return parents.where((parent) => parent['id'] == id).toList();
    } catch (e) {
      throw Exception('Erreur lors de la récupération du parent: $e');
    }
  }

  // Méthode pour mettre à jour un parent
  static Future<int> updateParent(
      int id, String nom, String prenom, String email, String password) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.put(
        Uri.parse('${ApiService.baseUrl}/parents/$id'),
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
      throw Exception('Erreur lors de la mise à jour du parent: $e');
    }
  }

  // Méthode pour supprimer un parent
  static Future<void> deleteParent(int id) async {
    throw Exception('Suppression de parent non implémentée dans l\'API');
  }

  // Méthode pour connecter un parent
  static Future<Parent?> loginParent(String email, String password) async {
    try {
      final response = await ApiService.parentLogin(email, password);
      if (response['success'] == true) {
        Map<String, dynamic> parentData = response['parent'] ?? response['user'] ?? response;
        if (parentData is Map<String, dynamic>) {
          if (parentData.containsKey('parent')) {
            parentData = parentData['parent'] as Map<String, dynamic>;
          } else if (parentData.containsKey('user')) {
            parentData = parentData['user'] as Map<String, dynamic>;
          }
        }
        if (parentData == null || !parentData.containsKey('id')) {
          throw Exception('Données utilisateur manquantes dans la réponse');
        }
        Parent parent = Parent.fromMap(parentData);
        parent.password = '';
        List<Eleve> children = [];
        try {
          final allElevesData = await ApiService.getAllEleves();
          for (var eleveData in allElevesData) {
            if (eleveData['parent'] != null && eleveData['parent']['id'] == parent.id) {
              Eleve eleve = Eleve.fromMap(eleveData as Map<String, dynamic>);
              if (eleve.classeId != null && eleve.classeId != 0) {
                try {
                  final classeData = await ApiService.getClasseById(eleve.classeId!);
                  if (classeData != null) {
                    eleve.classe = Classes.fromMap(classeData);
                  }
                } catch (e) {
                }
              }
              children.add(eleve);
            }
          }
          parent.setChildren(children);
        } catch (e) {
        }
        return parent;
      }
      return null;
    } catch (e) {
      throw Exception('Erreur lors de la connexion parent: $e');
    }
  }
}

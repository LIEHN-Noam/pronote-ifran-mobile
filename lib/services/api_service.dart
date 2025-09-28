import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ifran/models/seance.dart';

// Classe de service pour interagir avec l'API
class ApiService {
  // URL de base de l'API
  static const String baseUrl = 'https://upbeat-vagarious-casen.ngrok-free.dev/api';

  static final _storage = const FlutterSecureStorage();

  // En-têtes pour les requêtes API (sans authentification)
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // En-têtes avec authentification pour les requêtes protégées
  static Future<Map<String, String>> get authHeaders async {
    final token = await getToken();
    return {
      ...headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Récupérer le token d'authentification stocké
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Effacer le token d'authentification (déconnexion)
  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Stocker le token après une connexion réussie
  static Future<void> _storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Connexion parent
  static Future<Map<String, dynamic>> parentLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/parent-login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
        if (data['success'] == null && data.containsKey('id') && data is Map<String, dynamic>) {
          return {'user': data, 'success': true};
        }
        return data;
      } else {
        throw Exception('Échec de la connexion parent: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion parent: $e');
    }
  }

  // Connexion enseignant
  static Future<Map<String, dynamic>> teacherLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/teacher-login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
        if (data['success'] == true) {
          final userData = data['teacher'] ?? data['user'] ?? data;
          return {
            'success': true,
            'user': userData,
            ...Map.from(data)..remove('teacher'),
          };
        }
        if (data['success'] == null && data.containsKey('id') && data is Map<String, dynamic>) {
          return {'user': data, 'success': true};
        }
        return data;
      } else {
        throw Exception('Échec de la connexion enseignant: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion enseignant: $e');
    }
  }

  // Connexion coordinateur
  static Future<Map<String, dynamic>> coordinatorLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/coordinator-login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
        if (data['success'] == true) {
          final userData = data['coordinator'] ?? data['user'] ?? data;
          return {
            'success': true,
            'user': userData,
            ...Map.from(data)..remove('coordinator'),
          };
        }
        if (data['success'] == null && data.containsKey('id') && data is Map<String, dynamic>) {
          return {'user': data, 'success': true};
        }
        return data;
      } else {
        throw Exception('Échec de la connexion coordinateur: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion coordinateur: $e');
    }
  }

  // Connexion élève
  static Future<Map<String, dynamic>> studentLogin(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/student-login'),
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true && data['token'] != null) {
          await _storeToken(data['token']);
        }
        return data;
      } else {
        throw Exception('Échec de la connexion élève: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion élève: $e');
    }
  }

  // Récupérer la liste des parents
  static Future<List<dynamic>> getParents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/parents'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Échec de la récupération des parents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des parents: $e');
    }
  }

  // Récupérer tous les élèves
  static Future<List<dynamic>> getAllEleves() async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/students'),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data;
        } else if (data is Map<String, dynamic> && data['eleves'] is List) {
          return data['eleves'] as List<dynamic>;
        } else {
          return [];
        }
      } else {
        throw Exception('Échec de la récupération des élèves: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des élèves: $e');
    }
  }

  // Récupérer un élève par email
  static Future<Map<String, dynamic>?> getEleveByEmail(String email) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/students?email=$email'),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          return data;
        }
        return null;
      } else {
        throw Exception('Échec de la récupération de l\'élève par email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'élève par email: $e');
    }
  }

  // Récupérer un coordinateur par email
  static Future<Map<String, dynamic>?> getCoordinatorByEmail(String email) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/coordinators?email=$email'),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List && data.isNotEmpty) {
          return data[0] as Map<String, dynamic>;
        } else if (data is Map<String, dynamic>) {
          return data;
        }
        return null;
      } else {
        throw Exception('Échec de la récupération du coordinateur par email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération du coordinateur par email: $e');
    }
  }

  // Récupérer une classe par ID
  static Future<Map<String, dynamic>?> getClasseById(int id) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/classes/$id'),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body) as Map<String, dynamic>;
      } else {
        throw Exception('Échec de la récupération de la classe par ID: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de la classe par ID: $e');
    }
  }

  // Récupérer toutes les classes
  static Future<List<Map<String, dynamic>>> getAllClasses() async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/classes'),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data.cast<Map<String, dynamic>>();
        } else {
          return [];
        }
      } else {
        throw Exception('Échec de la récupération des classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des classes: $e');
    }
  }

  // Méthode générique pour vérifier les réponses API
  static bool isSuccessResponse(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  // Récupérer les séances
  Future<List<Seance>> fetchSeances() async {
    final response = await http.get(
      Uri.parse('$baseUrl/seances'),
      headers: {'Accept': 'application/json'},
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      if (jsonResponse['success'] == true) {
        final List<dynamic> data = jsonResponse['seances'];
        return data.map((item) => Seance.fromJson(item)).toList();
      } else {
        throw Exception('Erreur: success=false');
      }
    } else {
      throw Exception('Erreur serveur ${response.statusCode}');
    }
  }

  // Méthode pour vérifier la connexion à l'API
  static Future<bool> checkApiConnection() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 5));
      return isSuccessResponse(response.statusCode);
    } catch (e) {
      return false;
    }
  }
}

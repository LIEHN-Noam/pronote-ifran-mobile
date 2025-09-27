import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ifran/models/seance.dart';

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'https://upbeat-vagarious-casen.ngrok-free.dev/api';

  static final _storage = const FlutterSecureStorage();

  // Headers for API requests (without auth)
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

  // Auth headers for protected requests
  static Future<Map<String, String>> get authHeaders async {
    final token = await getToken();
    return {
      ...headers,
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // Get stored auth token
  static Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Clear stored auth token (logout)
  static Future<void> clearToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Store token after successful login
  static Future<void> _storeToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Parent Login
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
        print('DEBUG: Parent login response: ${response.body}');
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
        // Only wrap if it's a direct user object without 'success' wrapper
        if (data['success'] == null && data.containsKey('id') && data is Map<String, dynamic>) {
          return {'user': data, 'success': true};
        }
        return data;
      } else {
        throw Exception('Failed to login parent: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during parent login: $e');
    }
  }

  // Teacher Login
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
        print('DEBUG: Teacher login response: ${response.body}');
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
        // Standardize response: If 'success' true, map 'teacher' or 'user' to 'user' for consistency
        if (data['success'] == true) {
          final userData = data['teacher'] ?? data['user'] ?? data; // Fallback to direct data if no 'teacher' or 'user'
          return {
            'success': true,
            'user': userData,
            ...Map.from(data)..remove('teacher'), // Preserve other fields like message, redirect
          };
        }
        // Fallback: Wrap if direct user object without 'success'
        if (data['success'] == null && data.containsKey('id') && data is Map<String, dynamic>) {
          return {'user': data, 'success': true};
        }
        return data;
      } else {
        throw Exception('Failed to login teacher: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during teacher login: $e');
    }
  }

  // Coordinator Login
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
        print('DEBUG: Coordinator login response: ${response.body}');
        if (data['token'] != null) {
          await _storeToken(data['token']);
        }
        // Standardize response: If 'success' true, map 'coordinator' or 'user' to 'user' for consistency
        if (data['success'] == true) {
          final userData = data['coordinator'] ?? data['user'] ?? data; // Fallback to direct data if no 'coordinator' or 'user'
          return {
            'success': true,
            'user': userData,
            ...Map.from(data)..remove('coordinator'), // Preserve other fields like message, redirect
          };
        }
        // Fallback: Wrap if direct user object without 'success'
        if (data['success'] == null && data.containsKey('id') && data is Map<String, dynamic>) {
          return {'user': data, 'success': true};
        }
        return data;
      } else {
        throw Exception('Failed to login coordinator: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during coordinator login: $e');
    }
  }

  // Student Login
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
        throw Exception('Failed to login student: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during student login: $e');
    }
  }

  // Get Parents List
  static Future<List<dynamic>> getParents() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/parents'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch parents: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching parents: $e');
    }
  }

  // Get All Eleves List
  static Future<List<dynamic>> getAllEleves() async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/eleves'),
        headers: authHeaders,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to fetch eleves: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching eleves: $e');
    }
  }

  // Get Eleve by Email
  static Future<Map<String, dynamic>?> getEleveByEmail(String email) async {
    try {
      final authHeaders = await ApiService.authHeaders;
      final response = await http.get(
        Uri.parse('$baseUrl/eleves?email=$email'),
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
        throw Exception('Failed to fetch eleve by email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching eleve by email: $e');
    }
  }

  // Get Coordinator by Email
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
        throw Exception('Failed to fetch coordinator by email: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching coordinator by email: $e');
    }
  }
  // Get Classe by ID
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
        throw Exception('Failed to fetch classe by id: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching classe by id: $e');
    }
  }

  // Get All Classes
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
        throw Exception('Failed to fetch classes: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching classes: $e');
    }
  }
  // Generic method for handling API responses
  static bool isSuccessResponse(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }
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

  // Method to check if API is reachable
  static Future<bool> checkApiConnection() async {
    try {
      final response = await http.get(Uri.parse(baseUrl)).timeout(const Duration(seconds: 5));
      return isSuccessResponse(response.statusCode);
    } catch (e) {
      return false;
    }
  }
}

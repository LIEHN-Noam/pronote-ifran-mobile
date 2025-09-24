import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL for the API
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  // Headers for API requests
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };

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
        return jsonDecode(response.body);
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
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to login teacher: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error during teacher login: $e');
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
        return jsonDecode(response.body);
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

  // Generic method for handling API responses
  static bool isSuccessResponse(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
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

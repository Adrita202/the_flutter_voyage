import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String apiUrl =
      "http://10.0.2.2:5000/api/auth"; // Your backend base URL

  static Future<bool> sendOtp(String phone) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ph_no': phone}),
      );
      // Add print statements to log the response
      print('Send OTP Response status: ${response.statusCode}');
      print('Send OTP Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'] ?? '';
        return message.toLowerCase().contains('otp sent');
      } else {
        print('Server error: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error sending OTP: $e');
      return false; // Return false instead of throwing to maintain consistent return type
    }
  }

  // Method to verify OTP
  static Future<bool> verifyOtp(String phone, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$apiUrl/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'ph_no': phone, 'otp': otp}),
      );
      // Add print statements to log the response
      print('Verify OTP Response status: ${response.statusCode}');
      print('Verify OTP Response body: ${response.body}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData['message'] ?? '';

        // If verification is successful, save the auth token if provided
        if (message.toLowerCase().contains('otp verified successfully')) {
          // If verification is successful, save the auth token if provided
          if (responseData['token'] != null) {
            await _saveAuthToken(responseData['token']);
          }
          return true; // OTP verified successfully
        } else {
          return false; // OTP verification failed
        }
      } else {
        print('Server error: ${response.statusCode}');
        return false; // Return false if status code is not 200
      }
    } catch (e) {
      print('Error verifying OTP: $e');
      throw Exception('Failed to verify OTP: $e');
    }
  }

  // return response.statusCode == 200;

  // New method to check user role
  static Future<String?> getUserRole(String phone) async {
    try {
      // Retrieve saved auth token
      final token = await _getAuthToken();
      // Print debug information
      print('Checking user role for phone: $phone');
      print('Using token: $token');

      final response = await http.get(
        Uri.parse('$apiUrl/get-user-role?ph_no=$phone'),
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );
      // Print full response for debugging
      print('User role response status: ${response.statusCode}');
      print('User role response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // User found with a role
        if (responseData['success'] == true) {
          // Save user data to local storage for later use
          await _saveUserData(responseData['user']);
          return responseData['role'];
        }
        // User not found or no role assigned
        else if (responseData['success'] == false) {
          print(
            'User not found in backend response: ${responseData['message'] ?? "No message"}',
          );
          return null;
        }
      }
      // API error or user not found
      else if (response.statusCode == 404) {
        print('404: User not found');
        return null;
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }

      throw Exception('Failed to get user role: Unexpected response');
    } catch (e) {
      print('Error getting user role: $e');
      throw Exception('Failed to get user role: $e');
    }
  }

  // Helper method to save auth token
  static Future<void> _saveAuthToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  // Helper method to get auth token
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Helper method to save user data
  static Future<void> _saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();

    // Store user ID
    if (userData['id'] != null) {
      await prefs.setString('user_id', userData['id'].toString());
    }

    // Store user role
    if (userData['role'] != null) {
      await prefs.setString('user_role', userData['role']);
    }

    // Store phone number
    if (userData['phone'] != null) {
      await prefs.setString('user_phone', userData['phone']);
    }

    // Store name if available
    if (userData['name'] != null) {
      await prefs.setString('user_name', userData['name']);
    }

    // Store any other relevant user data
    // ...

    // Set login status
    await prefs.setBool('is_logged_in', true);
  }

  // Method to check if user is logged in
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  // Method to log out user
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data
  }
}

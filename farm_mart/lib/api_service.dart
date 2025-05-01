import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String apiUrl =
      "http://10.0.2.2:5000/api/auth"; // Your backend base URL

  static Future<bool> sendOtp(String phone) async {
    final response = await http.post(
      Uri.parse('$apiUrl/send-otp'),
      headers: {'Content-Type': 'application/json'},
     body: jsonEncode({'ph_no': phone}),

    );

    // Add print statements to log the response
    print('Send OTP Response status: ${response.statusCode}');
    print('Send OTP Response body: ${response.body}');

    return response.statusCode == 200;
  }

  static Future<bool> verifyOtp(String phone, String otp) async {
    final response = await http.post(
      Uri.parse('$apiUrl/verify-otp'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'ph_no': phone, 'otp': otp}),
    );

    // Add print statements to log the response
    print('Verify OTP Response status: ${response.statusCode}');
    print('Verify OTP Response body: ${response.body}');

    return response.statusCode == 200;
  }
}

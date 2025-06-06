import 'dart:convert';
import 'dart:developer';
import 'package:delivery_track_app/services/api_uri.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static Future<bool> register(String name, String email, String password) async {
    log('Register running...');

    if(name.isEmpty || email.isEmpty || password.isEmpty){
      log('Warning: name, email or password should be not empty!');
      return false;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password
      }),
    );

    if(response.statusCode != 201) {
      log('Error: User not created... status: ${response.statusCode}');
      return false;
    }

    return response.statusCode == 201;
  }

  static Future<String?> login(String email, String password) async {
    log('Login user');

    if(email.isEmpty || password.isEmpty){
      log('Warning: Email or password should be not empty');
      return null;
    }

    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      String token = data['token'];
      String userId = data['id'];

      if(token == ''){
        log('Error: Token is null');
        return null;
      }

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userId', userId);

      return token;
    }

    log('Error: User not created... status: ${response.statusCode}');
    return null;
  }

  static Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  static Future<String?> getToken() async{
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  static Future<String?> startDelivery(String token, String userId, int orders) async {
    if(orders == 0){
      return null;
    }
    
    final response = await http.post(
      Uri.parse('$baseUrl/init'),
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token',
      },
      body: jsonEncode({
        'userId': userId,
        'orders': orders
      }),
    );

    if(response.statusCode == 201){
      final data = jsonDecode(response.body);
      final linkMapa = data['link'];
      return linkMapa['link'];
    }

    return null;
  }

  static Future<bool> endDelivery(String token, String? deliveryId, String userId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/finish'),
      headers: {
        'Content-Type':'application/json',
        'Authorization':'Bearer $token'
      },
      body: jsonEncode({
        'deliveryId': deliveryId,
        'userId': userId
      })
    );

    return response.statusCode == 200;
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  static const String baseUrl = 'https://appskilltest.zybotech.in';
  final SharedPreferences sharedPreferences;
  final http.Client client;

  ApiClient({required this.sharedPreferences, required this.client});

  Future<Map<String, String>> _getHeaders() async {
    final token = sharedPreferences.getString('auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<http.Response> post(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    
    return await client.post(
      url,
      headers: headers,
      body: body != null ? json.encode(body) : null,
    );
  }

  Future<http.Response> get(String endpoint) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');
    
    return await client.get(
      url,
      headers: headers,
    );
  }

  Future<http.Response> delete(String endpoint, {Map<String, dynamic>? body}) async {
    final headers = await _getHeaders();
    final url = Uri.parse('$baseUrl$endpoint');

    final request = http.Request('DELETE', url)
      ..headers.addAll(headers);
      
    if (body != null) {
      request.body = json.encode(body);
    }

    final streamedResponse = await client.send(request);
    return await http.Response.fromStream(streamedResponse);
  }
}

import 'dart:convert';
import '../../../../core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> sendOtp(String phone);
  Future<String> createAccount(String phone, String nickname);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<Map<String, dynamic>> sendOtp(String phone) async {
    final response = await apiClient.post(
      '/auth/send-otp/',
      body: {'phone': phone},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data;
      }
      throw Exception('Failed to send OTP: ${data['status']}');
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  }

  @override
  Future<String> createAccount(String phone, String nickname) async {
    final response = await apiClient.post(
      '/auth/create-account/',
      body: {'phone': phone, 'nickname': nickname},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return data['token'];
      }
      throw Exception('Failed to create account');
    } else {
      throw Exception('Server Error: ${response.statusCode}');
    }
  }
}

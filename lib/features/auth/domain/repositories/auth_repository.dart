import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<String, Map<String, dynamic>>> sendOtp(String phone);
  Future<Either<String, String>> createAccount(String phone, String nickname);
  Future<void> saveAuthData(String token, String nickname);
  Future<String?> getToken();
  Future<String?> getNickname();
  Future<void> logout();
  Future<void> saveBudgetLimit(double limit);
  Future<double> getBudgetLimit();
}

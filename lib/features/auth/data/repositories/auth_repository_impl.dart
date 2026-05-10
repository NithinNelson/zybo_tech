import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<String, Map<String, dynamic>>> sendOtp(String phone) async {
    try {
      final response = await remoteDataSource.sendOtp(phone);
      return Right(response);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, String>> createAccount(String phone, String nickname) async {
    try {
      final token = await remoteDataSource.createAccount(phone, nickname);
      return Right(token);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<void> saveAuthData(String token, String nickname) async {
    await sharedPreferences.setString('auth_token', token);
    await sharedPreferences.setString('nickname', nickname);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString('auth_token');
  }

  @override
  Future<String?> getNickname() async {
    return sharedPreferences.getString('nickname');
  }
}

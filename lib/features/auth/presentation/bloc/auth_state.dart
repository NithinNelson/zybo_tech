import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthOtpSent extends AuthState {
  final String otp;
  final bool userExists;
  final String? nickname;
  final String? token;
  final String phone;

  const AuthOtpSent({
    required this.otp,
    required this.userExists,
    this.nickname,
    this.token,
    required this.phone,
  });

  @override
  List<Object?> get props => [otp, userExists, nickname, token, phone];
}

class AuthSuccess extends AuthState {
  final bool isNewUser;
  final String phone;

  const AuthSuccess({this.isNewUser = false, required this.phone});

  @override
  List<Object?> get props => [isNewUser, phone];
}

class AuthAuthenticated extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

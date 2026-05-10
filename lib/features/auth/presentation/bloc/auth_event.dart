import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class SendOtpEvent extends AuthEvent {
  final String phone;

  const SendOtpEvent(this.phone);

  @override
  List<Object> get props => [phone];
}

class VerifyOtpEvent extends AuthEvent {
  final String otp;
  final String expectedOtp;
  final bool userExists;
  final String? nickname;
  final String? token;
  final String phone;

  const VerifyOtpEvent({
    required this.otp,
    required this.expectedOtp,
    required this.userExists,
    this.nickname,
    this.token,
    required this.phone,
  });

  @override
  List<Object> get props => [otp, expectedOtp, userExists, phone];
}

class CreateAccountEvent extends AuthEvent {
  final String phone;
  final String nickname;

  const CreateAccountEvent({required this.phone, required this.nickname});

  @override
  List<Object> get props => [phone, nickname];
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository repository;

  AuthBloc({required this.repository}) : super(AuthInitial()) {
    on<SendOtpEvent>(_onSendOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<CreateAccountEvent>(_onCreateAccount);
    on<CheckAuthStatusEvent>(_onCheckAuthStatus);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onSendOtp(SendOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await repository.sendOtp(event.phone);
    
    result.fold(
      (error) => emit(AuthError(error)),
      (data) => emit(AuthOtpSent(
        otp: data['otp'].toString(),
        userExists: data['user_exists'] == true,
        nickname: data['nickname']?.toString(),
        token: data['token']?.toString(),
        phone: event.phone,
      )),
    );
  }

  Future<void> _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    if (event.otp == event.expectedOtp) {
      if (event.userExists && event.token != null && event.nickname != null) {
        await repository.saveAuthData(event.token!, event.nickname!);
        emit(AuthAuthenticated());
      } else {
        emit(AuthSuccess(isNewUser: true, phone: event.phone));
      }
    } else {
      emit(const AuthError('Invalid OTP. Please try again.'));
      emit(AuthOtpSent(
        otp: event.expectedOtp,
        userExists: event.userExists,
        nickname: event.nickname,
        token: event.token,
        phone: event.phone,
      ));
    }
  }

  Future<void> _onCreateAccount(CreateAccountEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await repository.createAccount(event.phone, event.nickname);
    
    result.fold(
      (error) => emit(AuthError(error)),
      (token) => token,
    );

    if (result.isRight()) {
      final token = result.getOrElse(() => '');
      await repository.saveAuthData(token, event.nickname);
      emit(AuthAuthenticated());
    }
  }

  Future<void> _onCheckAuthStatus(CheckAuthStatusEvent event, Emitter<AuthState> emit) async {
    final token = await repository.getToken();
    if (token != null && token.isNotEmpty) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<AuthState> emit) async {
    await repository.logout();
    emit(AuthUnauthenticated());
  }
}

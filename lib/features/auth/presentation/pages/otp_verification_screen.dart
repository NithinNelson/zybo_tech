import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/bloc/expense_bloc.dart';
import '../../../home/presentation/bloc/expense_event.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import 'user_name_screen.dart';
import '../../../../features/home/presentation/pages/home_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  static const int _totalSeconds = 60;
  final ValueNotifier<int> _remainingSeconds = ValueNotifier<int>(_totalSeconds);
  final ValueNotifier<bool> _isOtpValid = ValueNotifier<bool>(true);
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  void _startCountdown() {
    _remainingSeconds.value = _totalSeconds;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds.value <= 1) {
        timer.cancel();
        _remainingSeconds.value = 0;
        _isOtpValid.value = false;
      } else {
        _remainingSeconds.value--;
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _remainingSeconds.dispose();
    _isOtpValid.dispose();
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _verifyOtp(AuthOtpSent state) {
    if (_otpController.text.length == 6) {
      _countdownTimer?.cancel();
      context.read<AuthBloc>().add(
            VerifyOtpEvent(
              otp: _otpController.text,
              expectedOtp: state.otp,
              userExists: state.userExists,
              nickname: state.nickname,
              token: state.token,
              phone: state.phone,
            ),
          );
    }
  }

  void _resendOtp(String phone) {
    _otpController.clear();
    _isOtpValid.value = true;
    context.read<AuthBloc>().add(SendOtpEvent(phone));
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message), backgroundColor: AppColors.dangerRed),
              );
            } else if (state is AuthSuccess && state.isNewUser) {
              _countdownTimer?.cancel();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const UserNameScreen()),
              );
            } else if (state is AuthAuthenticated) {
              _countdownTimer?.cancel();
              context.read<ExpenseBloc>().add(FetchInitialDataEvent());
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (route) => false,
              );
            }
          },
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            
            String phone = '';
            String displayedOtp = '';
            
            if (state is AuthOtpSent) {
              phone = state.phone;
              displayedOtp = state.otp;
            }

            return SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.h),
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20.h),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.all(12.h),
                          decoration: BoxDecoration(
                            color: AppColors.background,
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(color: AppColors.neutralLight.withValues(alpha: 0.2)),
                          ),
                          child: Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 16.h,
                          ),
                        ),
                      ),
                      SizedBox(height: 55.h),
                      Text(
                        'Verify OTP',
                        style: Theme.of(context).textTheme.displayLarge,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Enter the 6-Digit code sent to $phone',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      if (displayedOtp.isNotEmpty)
                        ValueListenableBuilder<bool>(
                          valueListenable: _isOtpValid,
                          builder: (context, isValid, child) {
                            if (!isValid) return const SizedBox.shrink();
                            return Padding(
                              padding: EdgeInsets.only(top: 8.h),
                              child: Text(
                                'Test OTP: $displayedOtp',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppColors.emeraldGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          },
                        ),
                      SizedBox(height: 8.h),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Text(
                          'Change Number',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      SizedBox(height: 44.h),
                      Stack(
                        children: [
                          Opacity(
                            opacity: 0,
                            child: TextField(
                              controller: _otpController,
                              focusNode: _focusNode,
                              keyboardType: TextInputType.number,
                              maxLength: 6,
                              autofocus: true,
                              decoration: const InputDecoration(
                                counterText: '',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _focusNode.unfocus();
                              Future.delayed(const Duration(milliseconds: 10), () {
                                if (mounted) _focusNode.requestFocus();
                              });
                            },
                            behavior: HitTestBehavior.opaque,
                            child: ValueListenableBuilder<TextEditingValue>(
                              valueListenable: _otpController,
                              builder: (context, value, child) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: List.generate(
                                    6,
                                    (index) {
                                      final String char = value.text.length > index ? value.text[index] : '';

                                      return Container(
                                        width: 51.h,
                                        height: 64.h,
                                        decoration: BoxDecoration(
                                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(8.r),
                                        ),
                                        child: Center(
                                          child: Text(
                                            char.isEmpty ? '-' : char,
                                            style: GoogleFonts.inter(
                                              fontSize: 23.h,
                                              fontWeight: FontWeight.w400,
                                              color: AppColors.textPrimary.withValues(alpha: char.isEmpty ? 0.6 : 1.0),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 23.h),
                      ValueListenableBuilder<bool>(
                        valueListenable: _isOtpValid,
                        builder: (context, isValid, _) {
                          return ValueListenableBuilder<TextEditingValue>(
                            valueListenable: _otpController,
                            builder: (context, value, child) {
                              final bool isFilled = value.text.length == 6;
                              return ElevatedButton(
                                onPressed: isFilled && !isLoading && isValid
                                    ? () {
                                        if (state is AuthOtpSent) {
                                          _verifyOtp(state);
                                        }
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  foregroundColor: AppColors.textPrimary,
                                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.5),
                                  minimumSize: Size(double.infinity, 48.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  elevation: 0,
                                ),
                                child: isLoading
                                    ? SizedBox(
                                        height: 20.h,
                                        width: 20.h,
                                        child: const CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                      )
                                    : Text(
                                        'Verify',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 15.h,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: 32.h),
                      ValueListenableBuilder<int>(
                        valueListenable: _remainingSeconds,
                        builder: (context, seconds, child) {
                          if (seconds > 0) {
                            return Text(
                              'Resend OTP in ${seconds}s',
                              style: GoogleFonts.inter(
                                fontSize: 13.h,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary.withValues(alpha: 0.6),
                              ),
                            );
                          } else {
                            return GestureDetector(
                              onTap: phone.isNotEmpty ? () => _resendOtp(phone) : null,
                              child: Text(
                                'Resend OTP',
                                style: GoogleFonts.inter(
                                  fontSize: 13.h,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primary,
                                ),
                              ),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 50.h),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

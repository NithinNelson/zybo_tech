import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import 'user_name_screen.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _otpController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
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
                  'Enter the 6-Digit code sent to 8606****23',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(height: 8.h),
                GestureDetector(
                  onTap: () {
                    // Handle change number
                  },
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
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _otpController,
                  builder: (context, value, child) {
                    final bool isFilled = value.text.length == 6;
                    return ElevatedButton(
                      onPressed: isFilled
                          ? () {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const UserNameScreen(),
                                ),
                              );
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
                      child: Text(
                        'Verify',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 15.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 32.h),
                Text(
                    'Resend OTP in 32s',
                  style: GoogleFonts.inter(
                      fontSize: 13.h,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textPrimary.withValues(alpha: 0.6)
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

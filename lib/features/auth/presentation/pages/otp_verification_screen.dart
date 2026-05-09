import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h),
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
                      onChanged: (value) {
                        setState(() {});
                      },
                      decoration: const InputDecoration(
                        counterText: '',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _focusNode.requestFocus();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        6,
                        (index) {
                          String char = '';
                          if (_otpController.text.length > index) {
                            char = _otpController.text[index];
                          }
                          bool isFocused = _otpController.text.length == index;
                          
                          return Container(
                            width: 50.w,
                            height: 64.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isFocused ? AppColors.primary : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                char.isEmpty ? '-' : char,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 24.sp,
                                  fontWeight: FontWeight.bold,
                                  color: char.isEmpty ? Colors.white24 : Colors.white,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _otpController,
                builder: (context, value, child) {
                  bool isFilled = value.text.length == 6;
                  return ElevatedButton(
                    onPressed: isFilled
                        ? () {
                            // Handle verification
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
              Center(
                child: RichText(
                  text: TextSpan(
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Resend OTP in '),
                      TextSpan(
                        text: ' 32s',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

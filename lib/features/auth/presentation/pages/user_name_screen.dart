import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/pages/home_screen.dart';

class UserNameScreen extends StatefulWidget {
  const UserNameScreen({super.key});

  @override
  State<UserNameScreen> createState() => _UserNameScreenState();
}

class _UserNameScreenState extends State<UserNameScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 55.h),
              Text(
                '👋 What should we call you?',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              SizedBox(height: 8.h),
              Text(
                'This name stays only on your device.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              SizedBox(height: 48.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameController,
                builder: (context, value, child) {
                  final bool hasText = value.text.isNotEmpty;
                  return Container(
                    height: 56.h,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _nameController,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.textPrimary,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Eg: Johnnnie',
                              hintStyle: Theme.of(context).textTheme.bodyLarge,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        if (hasText)
                          SvgPicture.asset(
                            'assets/images/done_icon.svg',
                            height: 18.h,
                            fit: BoxFit.fitHeight,
                          ),
                      ],
                    ),
                  );
                },
              ),
              SizedBox(height: 24.h),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _nameController,
                builder: (context, value, child) {
                  final bool isEnabled = value.text.isNotEmpty;
                  return ElevatedButton(
                    onPressed: isEnabled
                        ? () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (context) => const HomeScreen()),
                              (route) => false,
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.textPrimary,
                      disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.3),
                      disabledForegroundColor: AppColors.textPrimary.withValues(alpha: 0.3),
                      minimumSize: Size(double.infinity, 48.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 15.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

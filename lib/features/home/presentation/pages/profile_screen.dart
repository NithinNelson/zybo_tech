import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 30.h),
          Text(
            'Profile & Settings',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 24.h),
          
          // Nickname Section
          _buildSectionHeader('NICKNAME'),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                Text(
                  'Naazley',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: EdgeInsets.all(8.h),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Icon(Icons.edit_outlined, color: Colors.white, size: 16.sp),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Alert Limit Section
          _buildSectionHeader('ALERT LIMIT (₹)'),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Amount ( ₹ )',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.sp,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(60.w, 50.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text('Set', style: GoogleFonts.plusJakartaSans(fontSize: 14.sp)),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Current Limit: ₹1,000',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Categories Section
          _buildSectionHeader('CATEGORIES'),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: const Color(0xFF121212),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'New category Name',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 14.sp,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Container(
                      width: 50.h,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(Icons.add, color: Colors.white, size: 24.sp),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                _buildCategoryItem('Food'),
                _buildCategoryItem('Bills'),
                _buildCategoryItem('Transport'),
                _buildCategoryItem('Shopping'),
              ],
            ),
          ),
          
          SizedBox(height: 24.h),
          
          // Cloud Sync Section
          _buildSectionHeader('CLOUD SYNC'),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync To Cloud',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Sync and update data to the backend',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.cloud_upload_outlined, color: Colors.white, size: 28.sp),
              ],
            ),
          ),
          
          SizedBox(height: 32.h),
          
          // Logout Button
          Center(
            child: TextButton.icon(
              onPressed: () {},
              icon: Icon(Icons.power_settings_new, color: Colors.redAccent, size: 20.sp),
              label: Text(
                'Log Out',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
          SizedBox(height: 120.h),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        title,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        children: [
          Text(
            name,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            padding: EdgeInsets.all(8.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: Colors.white10),
            ),
            child: Icon(Icons.delete_outline, color: Colors.redAccent.withOpacity(0.5), size: 16.sp),
          ),
        ],
      ),
    );
  }
}

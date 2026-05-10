import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
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
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 19.h,
            ),
          ),
          SizedBox(height: 24.h),
          
          _buildSectionHeader('NICKNAME'),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Row(
              children: [
                Text(
                  'Naazley',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 19.h,
                  ),
                ),
                const Spacer(),
                Container(
                  width: 36.h,
                  height: 36.h,
                  decoration: BoxDecoration(
                    color: AppColors.black,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.textPrimary, width: 1.h),
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      'assets/images/edit_pencil.svg',
                      height: 13.h,
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            thickness: 3.h,
            height: 36.h,
          ),

          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader('ALERT LIMIT (₹)'),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16.h),
                            Text(
                              'Amount ',
                              style: GoogleFonts.inter(
                                fontSize: 17.h,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary.withValues(alpha: 0.6),
                              ),
                            ),
                            Text(
                              '( ₹ )',
                              style: GoogleFonts.inter(
                                fontSize: 17.h,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.h),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(54.h, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                          'Set',
                          style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Text(
                  'Current Limit: ₹1,000',
                  style: GoogleFonts.inter(
                    fontSize: 13.h,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                )
              ],
            ),
          ),

          Divider(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            thickness: 3.h,
            height: 36.h,
          ),
          
          _buildSectionHeader('CATEGORIES'),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48.h,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 16.h),
                            Text(
                              'New category Name',
                              style: GoogleFonts.inter(
                                fontSize: 13.h,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 12.h),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        minimumSize: Size(48.h, 48.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(
                  color: AppColors.textPrimary.withValues(alpha: 0.1),
                  thickness: 1.h,
                  height: 36.h,
                ),
                _buildCategoryItem('Food'),
                _buildCategoryItem('Bills'),
                _buildCategoryItem('Transport'),
                _buildCategoryItem('Shopping', 0),
              ],
            ),
          ),

          Divider(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            thickness: 3.h,
            height: 36.h,
          ),
          
          _buildSectionHeader('CLOUD SYNC'),
          Container(
            padding: EdgeInsets.all(16.h),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
            ),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
              decoration: BoxDecoration(
                color: Color(0xFF4340CA).withValues(alpha: 0.54),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sync To Cloud',
                        style: GoogleFonts.inter(
                          fontSize: 17.h,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        'Sync and update data to the backend',
                        style: GoogleFonts.inter(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  SvgPicture.asset(
                      'assets/images/cloud_sync.svg',
                    height: 18.h,
                    fit: BoxFit.fitHeight,
                  ),
                ],
              ),
            ),
          ),
          
          SizedBox(height: 32.h),

          SizedBox(
            width: double.infinity,
            child: TextButton.icon(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: AppColors.background,
                padding: EdgeInsets.all(16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(
                    color: AppColors.textPrimary.withValues(alpha: 0.1),
                  ),
                ),
              ),
              icon: SvgPicture.asset(
                'assets/images/logout.svg',
                height: 17.h,
                fit: BoxFit.fitHeight,
              ),
              iconAlignment: IconAlignment.end,
              label: Text(
                'Log Out',
                style: GoogleFonts.inter(
                  fontSize: 14.h,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFFF2929),
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
      padding: EdgeInsets.only(bottom: 10.h),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 13.h,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCategoryItem(String name, [double? padding]) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 16.h),
      child: Row(
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 15.h,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          const Spacer(),
          Container(
            width: 40.h,
            height: 40.h,
            decoration: BoxDecoration(
              color: AppColors.crimson.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.crimson),
            ),
            child: Center(
              child: SvgPicture.asset(
                'assets/images/delete_icon.svg',
                height: 13.h,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

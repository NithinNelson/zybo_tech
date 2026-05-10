import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.h),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
          SliverToBoxAdapter(
            child: Text(
              '👋 Welcome, Naazley!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 19.h,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          SliverToBoxAdapter(
            child: Row(
              children: [
                _buildStatCard(
                  context: context,
                  title: 'Total Income',
                  amount: '₹90,000',
                  isIncome: true,
                  gradient: const LinearGradient(
                    colors: [AppColors.forestGreen, AppColors.darkForestGreen],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                SizedBox(width: 16.h),
                _buildStatCard(
                  context: context,
                  title: 'Total Expense',
                  amount: '₹36,345',
                  isIncome: false,
                  gradient: const LinearGradient(
                    colors: [AppColors.crimson, AppColors.blackMaroon],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Container(
              padding: EdgeInsets.all(16.h),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'MONTHLY LIMIT',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        '₹7,324',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        ' / ₹10,000',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: LinearProgressIndicator(
                      value: 0.73,
                      minHeight: 8.h,
                      backgroundColor: AppColors.lightGrey,
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4CAF50)),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '27% Remaining',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
              child: Divider(
                  color: AppColors.textPrimary.withValues(alpha: 0.05),
                  thickness: 2.h,
                  height: 48.h,
              ),
          ),
          SliverToBoxAdapter(
            child: Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return _buildTransactionItem(context);
              },
              childCount: 6,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 180.h)),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String amount,
    required bool isIncome,
    required Gradient gradient,
    required BuildContext context,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.h),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isIncome
                ? AppColors.forestGreen.withValues(alpha: 0.3)
                : AppColors.crimson.withValues(alpha: 0.3)
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                SvgPicture.asset(
                  isIncome ? "assets/images/arrow_down.svg" : "assets/images/arrow_up.svg",
                  height: 15.h,
                  fit: BoxFit.fitHeight,
                ),
                SizedBox(width: 8.h),
                Text(
                  amount,
                  style: Theme.of(context).textTheme.displayLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceBlack,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: Container(
              width: 28.h,
              height: 28.h,
              decoration: BoxDecoration(
                color: AppColors.charcoal,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/shopping_bag.svg',
                  height: 15.h,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Grocery Store',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Food',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontSize: 13.h,
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '12th Dec 2026',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.silver,
                ),
              ),
              Text(
                '-₹36,345',
                style: GoogleFonts.inter(
                  fontSize: 21.h,
                  fontWeight: FontWeight.w500,
                  color: AppColors.alertRed,
                ),
              ),
            ],
          ),
          SizedBox(width: 8.h),
          Padding(
            padding: EdgeInsets.only(top: 3.h),
            child: Icon(Icons.delete, color: AppColors.dangerRed, size: 25.h),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../widgets/dashboard_view.dart';
import 'transactions_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const DashboardView(),
    const TransactionsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.h),
              child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
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
            ),
            Positioned(
              bottom: 120.h,
              right: 20.h,
              child: Container(
                width: 56.h,
                height: 56.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.emeraldGreen,
                        AppColors.deepEmerald
                      ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.textPrimary.withValues(alpha: 0.12),
                      blurRadius: 25,
                      spreadRadius: 0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: SvgPicture.asset(
                      "assets/images/add_icon.svg",
                      height: 18.h,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 20.h,
              left: 80.w,
              right: 80.w,
              child: Container(
                // height: 64.h,
                padding: EdgeInsets.all(3.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF262626),
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                      color: AppColors.textPrimary.withValues(alpha: 0.3),
                      width: 1.h,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildNavItem(0, 'assets/images/pie_slice.svg'),
                    _buildNavItem(1, 'assets/images/arrow_round.svg'),
                    _buildNavItem(2, 'assets/images/user_circle.svg'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, String assetPath) {
    final bool isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 52.h,
        height: 52.h,
        padding: EdgeInsets.all(12.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: SvgPicture.asset(
          assetPath,
          colorFilter: ColorFilter.mode(
            isActive ? Colors.white : AppColors.textPrimary.withValues(alpha: 0.6),
            BlendMode.srcIn,
          ),
          fit: BoxFit.contain,
        ),
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

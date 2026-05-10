import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/theme/app_colors.dart';
import 'dashboard_view.dart';
import 'transactions_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  late final ValueNotifier<int> _currentIndexNotifier;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _currentIndexNotifier = ValueNotifier<int>(0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    _currentIndexNotifier.value = index;
  }

  void _onNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOutCubicEmphasized,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const BouncingScrollPhysics(),
              children: const [
                DashboardView(),
                TransactionsScreen(),
                ProfileScreen(),
              ],
            ),

            Positioned(
              bottom: 120.h,
              right: 20.h,
              child: ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (context, currentIndex, _) {
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 200),
                    opacity: currentIndex == 0 ? 1.0 : 0.0,
                    child: IgnorePointer(
                      ignoring: currentIndex != 0,
                      child: _AddButton(),
                    ),
                  );
                },
              ),
            ),

            Positioned(
              bottom: 20.h,
              left: 80.w,
              right: 80.w,
              child: ValueListenableBuilder<int>(
                valueListenable: _currentIndexNotifier,
                builder: (context, currentIndex, _) {
                  return _BottomNavBar(
                    currentIndex: currentIndex,
                    onTap: _onNavTap,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavBar({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _NavItem(
            index: 0,
            isActive: currentIndex == 0,
            assetPath: 'assets/images/pie_slice.svg',
            onTap: () => onTap(0),
          ),
          _NavItem(
            index: 1,
            isActive: currentIndex == 1,
            assetPath: 'assets/images/arrow_round.svg',
            onTap: () => onTap(1),
          ),
          _NavItem(
            index: 2,
            isActive: currentIndex == 2,
            assetPath: 'assets/images/user_circle.svg',
            onTap: () => onTap(2),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final int index;
  final bool isActive;
  final String assetPath;
  final VoidCallback onTap;

  const _NavItem({
    required this.index,
    required this.isActive,
    required this.assetPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
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
}

class _AddButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.h,
      height: 56.h,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.emeraldGreen,
            AppColors.deepEmerald,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.12),
            blurRadius: 25,
            spreadRadius: 0,
            offset: const Offset(0, 4),
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
    );
  }
}

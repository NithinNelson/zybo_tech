import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../../data/models/category_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../injection_container.dart' as di;
import '../../../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../../../features/auth/presentation/bloc/auth_event.dart';
import '../../../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../../../features/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../../../features/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _limitController = TextEditingController();
  final _uuid = const Uuid();
  String _nickname = 'User';

  @override
  void initState() {
    super.initState();
    _loadNickname();
  }

  Future<void> _loadNickname() async {
    final prefs = di.sl<SharedPreferences>();
    setState(() {
      _nickname = prefs.getString('nickname') ?? 'User';
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _categoryController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  void _addCategory() {
    final name = _categoryController.text.trim();
    if (name.isNotEmpty) {
      final newCategory = CategoryModel(
        id: _uuid.v4(),
        name: name,
      );
      context.read<ExpenseBloc>().add(AddCategoryEvent(newCategory));
      _categoryController.clear();
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SingleChildScrollView(
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
                    _nickname,
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

            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                final currentLimit = state is ExpenseLoaded ? state.budgetLimit : 1000.0;
                
                return Container(
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
                              child: TextField(
                                controller: _limitController,
                                style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14.h),
                                decoration: InputDecoration(
                                  hintText: 'Amount ( ₹ )',
                                  hintStyle: GoogleFonts.inter(
                                    fontSize: 16.h,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.h),
                          ElevatedButton(
                            onPressed: () {
                              final limit = double.tryParse(_limitController.text);
                              if (limit != null) {
                                context.read<ExpenseBloc>().add(SetBudgetLimitEvent(limit));
                                _limitController.clear();
                                FocusManager.instance.primaryFocus?.unfocus();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Monthly limit updated to ₹$limit')),
                                );
                              }
                            },
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
                        'Current Limit: ₹${NumberFormat('#,##,###').format(currentLimit)}',
                        style: GoogleFonts.inter(
                          fontSize: 13.h,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textPrimary,
                        ),
                      )
                    ],
                  ),
                );
              },
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
                          child: TextField(
                            controller: _categoryController,
                            style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14.h),
                            decoration: InputDecoration(
                              hintText: 'New category Name',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 13.h,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textPrimary.withValues(alpha: 0.6),
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 16.h),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.h),
                      ElevatedButton(
                        onPressed: _addCategory,
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
                  BlocBuilder<ExpenseBloc, ExpenseState>(
                    builder: (context, state) {
                      if (state is ExpenseLoaded) {
                        if (state.categories.isEmpty) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 20.h),
                            child: Text(
                              'No categories created.',
                              style: TextStyle(color: AppColors.textPrimary.withValues(alpha: 0.5)),
                            ),
                          );
                        }
                        return Column(
                          children: List.generate(state.categories.length, (index) {
                            final category = state.categories[index];
                            final isLast = index == state.categories.length - 1;
                            return _buildCategoryItem(category, isLast ? 0 : 16.h);
                          }),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            ),

            Divider(
              color: AppColors.textPrimary.withValues(alpha: 0.05),
              thickness: 3.h,
              height: 36.h,
            ),
            
            _buildSectionHeader('CLOUD SYNC'),
            BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                final isSyncing = state is ExpenseLoaded && state.isSyncing;
                return GestureDetector(
                  onTap: () {
                    if (!isSyncing) {
                      context.read<ExpenseBloc>().add(SyncDataEvent());
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.h),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: AppColors.textPrimary.withValues(alpha: 0.1)),
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4340CA).withValues(alpha: 0.54),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isSyncing ? 'Syncing...' : 'Sync To Cloud',
                                style: GoogleFonts.inter(
                                  fontSize: 17.h,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              Text(
                                isSyncing ? 'Please wait...' : 'Sync and update data to the backend',
                                style: GoogleFonts.inter(
                                  fontSize: 13.h,
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.textPrimary.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          if (isSyncing)
                            SizedBox(
                              height: 20.h,
                              width: 20.h,
                              child: const CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          else
                            SvgPicture.asset(
                              'assets/images/cloud_sync.svg',
                              height: 18.h,
                              fit: BoxFit.fitHeight,
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            
            SizedBox(height: 32.h),

            SizedBox(
              width: double.infinity,
              child: TextButton.icon(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      backgroundColor: const Color(0xFF1E1E1E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      title: Text(
                        'Log Out',
                        style: GoogleFonts.inter(
                          fontSize: 17.h,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      content: Text(
                        'Are you sure you want to log out? All local data will be cleared.',
                        style: GoogleFonts.inter(
                          fontSize: 14.h,
                          color: AppColors.textPrimary.withValues(alpha: 0.7),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(ctx),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.inter(
                              fontSize: 14.h,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textPrimary.withValues(alpha: 0.6),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(ctx);
                            context.read<AuthBloc>().add(LogoutEvent());
                            context.read<OnboardingBloc>().add(ResetOnboarding());
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(builder: (_) => const OnboardingScreen()),
                              (route) => false,
                            );
                          },
                          child: Text(
                            'Log Out',
                            style: GoogleFonts.inter(
                              fontSize: 14.h,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFFFF2929),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
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
                    color: const Color(0xFFFF2929),
                  ),
                ),
              ),
            ),
            SizedBox(height: 120.h),
          ],
        ),
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

  Widget _buildCategoryItem(CategoryModel category, [double? padding]) {
    return Padding(
      padding: EdgeInsets.only(bottom: padding ?? 16.h),
      child: Row(
        children: [
          Text(
            category.name,
            style: GoogleFonts.inter(
              fontSize: 15.h,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          if (category.isSynced) ...[
            SizedBox(width: 8.h),
            Icon(Icons.cloud_done, color: AppColors.emeraldGreen, size: 14.h),
          ],
          const Spacer(),
          GestureDetector(
            onTap: () {
              context.read<ExpenseBloc>().add(DeleteCategoryEvent(category.id));
            },
            child: Container(
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
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../../data/models/transaction_model.dart';
import 'package:intl/intl.dart';

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
      child: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          if (state is ExpenseInitial || state is ExpenseLoading) {
            return _buildShimmer();
          }

          if (state is ExpenseLoaded) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: SizedBox(height: 30.h)),
                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '👋 Welcome!',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontSize: 19.h,
                        ),
                      ),
                      if (state.isSyncing)
                        SizedBox(
                          height: 20.h,
                          width: 20.h,
                          child: const CircularProgressIndicator(strokeWidth: 2),
                        ),
                    ],
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 24.h)),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      _buildStatCard(
                        context: context,
                        title: 'Total Income',
                        amount: '₹${state.totalIncome.toStringAsFixed(2)}',
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
                        amount: '₹${state.totalExpense.toStringAsFixed(2)}',
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
                  child: _buildLimitTracker(context, state.totalExpense),
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
                if (state.transactions.isEmpty)
                  SliverToBoxAdapter(
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40.h),
                        child: Text(
                          'No transactions yet.',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary.withValues(alpha: 0.5),
                          ),
                        ),
                      ),
                    ),
                  )
                else
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return _buildTransactionItem(context, state.transactions[index]);
                      },
                      childCount: state.transactions.length > 10 ? 10 : state.transactions.length, // List 10 recent
                    ),
                  ),
                SliverToBoxAdapter(child: SizedBox(height: 180.h)),
              ],
            );
          }

          if (state is ExpenseError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLimitTracker(BuildContext context, double totalExpense) {
    const double limit = 1000.0;
    final double percentage = (totalExpense / limit).clamp(0.0, 1.0);
    final double remaining = limit - totalExpense;

    return Container(
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
                '₹${totalExpense.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                ' / ₹${limit.toStringAsFixed(2)}',
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
              value: percentage,
              minHeight: 8.h,
              backgroundColor: AppColors.lightGrey,
              valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 1.0 ? AppColors.dangerRed : const Color(0xFF4CAF50)),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            remaining > 0 
                ? '${((1 - percentage) * 100).toStringAsFixed(0)}% Remaining' 
                : 'Limit Exceeded!',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: percentage >= 1.0 ? AppColors.dangerRed : AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
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
                Expanded(
                  child: Text(
                    amount,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 20.h),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionItem(BuildContext context, TransactionModel transaction) {
    final bool isCredit = transaction.type == 'credit';
    final String sign = isCredit ? '+' : '-';
    final Color color = isCredit ? AppColors.emeraldGreen : AppColors.alertRed;
    
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
                  colorFilter: transaction.isSynced 
                      ? const ColorFilter.mode(AppColors.emeraldGreen, BlendMode.srcIn)
                      : null,
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
                  transaction.note,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  transaction.categoryName ?? 'Unknown Category', // Display category name from JOIN
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
                DateFormat('dd MMM yyyy').format(transaction.timestamp),
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: AppColors.silver,
                ),
              ),
              Text(
                '$sign₹${transaction.amount.toStringAsFixed(2)}',
                style: GoogleFonts.inter(
                  fontSize: 21.h,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          SizedBox(width: 8.h),
          GestureDetector(
            onTap: () {
              context.read<ExpenseBloc>().add(DeleteTransactionEvent(transaction.id));
            },
            child: Padding(
              padding: EdgeInsets.only(top: 3.h),
              child: Icon(Icons.delete, color: AppColors.dangerRed, size: 25.h),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: AppColors.surfaceBlack,
      highlightColor: AppColors.charcoal,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: 30.h)),
          SliverToBoxAdapter(
            child: Container(width: 200.w, height: 24.h, color: Colors.white),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 24.h)),
          SliverToBoxAdapter(
            child: Row(
              children: [
                Expanded(child: Container(height: 100.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)))),
                SizedBox(width: 16.h),
                Expanded(child: Container(height: 100.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r)))),
              ],
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 16.h)),
          SliverToBoxAdapter(
            child: Container(height: 120.h, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12.r))),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 48.h)),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  height: 60.h,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
                );
              },
              childCount: 6,
            ),
          ),
        ],
      ),
    );
  }
}

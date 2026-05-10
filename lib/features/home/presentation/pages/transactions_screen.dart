import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../../data/models/transaction_model.dart';
import 'package:shimmer/shimmer.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Transactions',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 19.h,
                ),
              ),
              // BlocBuilder<ExpenseBloc, ExpenseState>(
              //   builder: (context, state) {
              //     return IconButton(
              //       onPressed: () {
              //         context.read<ExpenseBloc>().add(SyncDataEvent());
              //       },
              //       icon: state is ExpenseLoaded && state.isSyncing
              //           ? SizedBox(height: 20.h, width: 20.h, child: const CircularProgressIndicator(strokeWidth: 2))
              //           : Icon(Icons.sync, color: AppColors.primary, size: 24.h),
              //     );
              //   },
              // ),
            ],
          ),
        ),
        SizedBox(height: 28.h),
        Expanded(
          child: BlocBuilder<ExpenseBloc, ExpenseState>(
            builder: (context, state) {
              if (state is ExpenseInitial || state is ExpenseLoading) {
                return _buildShimmer();
              }

              if (state is ExpenseError) {
                return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
              }

              if (state is ExpenseLoaded) {
                if (state.transactions.isEmpty) {
                  return Center(
                    child: Text(
                      'No transactions yet.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary.withValues(alpha: 0.5),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 100.h),
                  itemCount: state.transactions.length,
                  itemBuilder: (context, index) {
                    return _buildTransactionItem(context, state.transactions[index]);
                  },
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ],
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
                  isCredit ? 'assets/images/liquid_drop.svg' : 'assets/images/shopping_bag.svg',
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
                  transaction.categoryName ?? 'Unknown Category',
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
      child: ListView.builder(
        padding: EdgeInsets.only(left: 20.h, right: 20.h, bottom: 100.h),
        itemCount: 8,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            height: 70.h,
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.r)),
          );
        },
      ),
    );
  }
}

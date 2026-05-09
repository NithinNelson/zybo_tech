import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 30.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.h),
          child: Text(
            'Transactions',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 19.h,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.h),
            physics: const BouncingScrollPhysics(),
            itemCount: 15,
            itemBuilder: (context, index) {
              return _buildTransactionItem(context, index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(BuildContext context, int index) {
    final bool isExpense = index % 2 == 0;
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
                  isExpense ? 'assets/images/shopping_bag.svg' : 'assets/images/drop_icon.svg',
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
                  isExpense ? 'Grocery Store' : 'Electricity Bill',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  isExpense ? 'Food' : 'Bills',
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
                isExpense ? '-₹36,345' : '+₹379',
                style: GoogleFonts.inter(
                  fontSize: 21.h,
                  fontWeight: FontWeight.w500,
                  color: isExpense ? AppColors.alertRed : AppColors.emeraldGreen,
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

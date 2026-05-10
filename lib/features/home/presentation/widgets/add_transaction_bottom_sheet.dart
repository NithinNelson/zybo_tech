import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import '../../../../core/theme/app_colors.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  State<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  late final ValueNotifier<bool> _isExpenseNotifier;
  late final ValueNotifier<String> _selectedCategoryNotifier;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final List<String> _categories = ['Food', 'Bills', 'Transport', 'Shopping'];

  @override
  void initState() {
    super.initState();
    _isExpenseNotifier = ValueNotifier<bool>(true);
    _selectedCategoryNotifier = ValueNotifier<String>('Bills');
  }

  @override
  void dispose() {
    _isExpenseNotifier.dispose();
    _selectedCategoryNotifier.dispose();
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
        decoration: BoxDecoration(
          color: Color(0xFF1F1F1F),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Add Transaction',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Text(
                    'Close',
                    style: GoogleFonts.inter(
                      fontSize: 13.h,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            ValueListenableBuilder<bool>(
              valueListenable: _isExpenseNotifier,
              builder: (context, isExpense, _) {
                return Container(
                  height: 56.h,
                  padding: EdgeInsets.all(4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F1F1F),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.charcoal),
                  ),
                  child: Row(
                    children: [
                      _ToggleItem(
                        label: 'Expense',
                        isActive: isExpense,
                        onTap: () => _isExpenseNotifier.value = true,
                      ),
                      _ToggleItem(
                        label: 'Income',
                        isActive: !isExpense,
                        onTap: () => _isExpenseNotifier.value = false,
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),

            _buildTextField(
              controller: _titleController,
              hint: 'Title',
            ),
            SizedBox(height: 16.h),

            _buildTextField(
              controller: _amountController,
              hint: 'Amount ( ₹ )',
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 24.h),

            Text(
              'CATEGORY',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.6),
              ),
            ),
            SizedBox(height: 12.h),
            ValueListenableBuilder<String>(
              valueListenable: _selectedCategoryNotifier,
              builder: (context, selectedCategory, _) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _categories.map((category) {
                      return _CategoryChip(
                        label: category,
                        isSelected: selectedCategory == category,
                        onTap: () => _selectedCategoryNotifier.value = category,
                      );
                    }).toList(),
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),

            const _InfoBanner(),
            SizedBox(height: 30.h),

            SizedBox(
              width: double.infinity,
              height: 48.h,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Save',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.textPrimary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 15.h),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.inter(
              color: AppColors.textPrimary.withValues(alpha: 0.6),
              fontSize: 14.h,
              fontWeight: FontWeight.w400,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 16.h),
          border: InputBorder.none,
        ),
      ),
    );
  }
}

class _ToggleItem extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF1DC533) : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.h),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary.withValues(alpha: 0.5) : Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.iceBlue : AppColors.textPrimary.withValues(alpha: 0.2),
            ),
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: isSelected ? AppColors.textPrimary : AppColors.textPrimary.withValues(alpha: 0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  const _InfoBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.emeraldPrimary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.emeraldPrimary.withValues(alpha: 0.1), width: 1.h),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.h),
            child: SvgPicture.asset(
              'assets/images/info_i.svg',
              height: 16.h,
              fit: BoxFit.fitHeight,
            ),
          ),
          SizedBox(width: 12.h),
          Expanded(
            child: Text(
              'Everything you add here is saved only on your device.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

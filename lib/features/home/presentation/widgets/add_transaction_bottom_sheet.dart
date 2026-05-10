import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/theme/app_colors.dart';
import '../bloc/expense_bloc.dart';
import '../bloc/expense_event.dart';
import '../bloc/expense_state.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';

class AddTransactionBottomSheet extends StatefulWidget {
  const AddTransactionBottomSheet({super.key});

  @override
  State<AddTransactionBottomSheet> createState() => _AddTransactionBottomSheetState();
}

class _AddTransactionBottomSheetState extends State<AddTransactionBottomSheet> {
  late final ValueNotifier<bool> _isExpenseNotifier;
  late final ValueNotifier<CategoryModel?> _selectedCategoryNotifier;
  
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _isExpenseNotifier = ValueNotifier<bool>(true);
    _selectedCategoryNotifier = ValueNotifier<CategoryModel?>(null);
    
    // Auto-select first category if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<ExpenseBloc>().state;
      if (state is ExpenseLoaded && state.categories.isNotEmpty) {
        _selectedCategoryNotifier.value = state.categories.first;
      }
    });
  }

  @override
  void dispose() {
    _isExpenseNotifier.dispose();
    _selectedCategoryNotifier.dispose();
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    final title = _titleController.text.trim();
    final amountText = _amountController.text.trim();
    final category = _selectedCategoryNotifier.value;
    final isExpense = _isExpenseNotifier.value;

    if (title.isEmpty || amountText.isEmpty || category == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select a category')),
      );
      return;
    }

    final amount = double.tryParse(amountText);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    final transaction = TransactionModel(
      id: _uuid.v4(),
      amount: amount,
      note: title,
      type: isExpense ? 'debit' : 'credit',
      categoryId: category.id,
      categoryName: category.name,
      timestamp: DateTime.now(),
      isSynced: false,
      isDeleted: false,
    );

    context.read<ExpenseBloc>().add(AddTransactionEvent(transaction));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: KeyboardAvoider(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.h, vertical: 24.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1F1F1F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
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
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                SizedBox(height: 24.h),

                Text(
                  'CATEGORY',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary.withValues(alpha: 0.6),
                  ),
                ),
                SizedBox(height: 12.h),
                BlocBuilder<ExpenseBloc, ExpenseState>(
                  builder: (context, state) {
                    if (state is ExpenseLoaded) {
                      if (state.categories.isEmpty) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.h),
                          child: Text(
                            'No categories available. Please add one in Profile -> Categories.',
                            style: TextStyle(color: AppColors.dangerRed, fontSize: 13.h),
                          ),
                        );
                      }
                      
                      return ValueListenableBuilder<CategoryModel?>(
                        valueListenable: _selectedCategoryNotifier,
                        builder: (context, selectedCategory, _) {
                          // Auto select first if null
                          if (selectedCategory == null && state.categories.isNotEmpty) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              _selectedCategoryNotifier.value = state.categories.first;
                            });
                          }
                          
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: state.categories.map((category) {
                                return _CategoryChip(
                                  label: category.name,
                                  isSelected: selectedCategory?.id == category.id,
                                  onTap: () => _selectedCategoryNotifier.value = category,
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                SizedBox(height: 24.h),

                const _InfoBanner(),
                SizedBox(height: 30.h),

                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: _saveTransaction,
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
            color: isSelected ? AppColors.primary.withValues(alpha: 0.5) : const Color(0xFF2A2A2A),
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
              'Everything you add here is saved only on your device until you sync.',
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

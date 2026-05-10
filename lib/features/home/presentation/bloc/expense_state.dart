import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';

abstract class ExpenseState extends Equatable {
  const ExpenseState();
  
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<TransactionModel> transactions;
  final List<CategoryModel> categories;
  final double totalExpense;
  final double totalIncome;
  final bool isSyncing;
  final String nickname;
  final double budgetLimit;

  const ExpenseLoaded({
    required this.transactions,
    required this.categories,
    required this.totalExpense,
    required this.totalIncome,
    required this.nickname,
    this.isSyncing = false,
    this.budgetLimit = 1000.0,
  });

  ExpenseLoaded copyWith({
    List<TransactionModel>? transactions,
    List<CategoryModel>? categories,
    double? totalExpense,
    double? totalIncome,
    bool? isSyncing,
    String? nickname,
    double? budgetLimit,
  }) {
    return ExpenseLoaded(
      transactions: transactions ?? this.transactions,
      categories: categories ?? this.categories,
      totalExpense: totalExpense ?? this.totalExpense,
      totalIncome: totalIncome ?? this.totalIncome,
      isSyncing: isSyncing ?? this.isSyncing,
      nickname: nickname ?? this.nickname,
      budgetLimit: budgetLimit ?? this.budgetLimit,
    );
  }

  @override
  List<Object?> get props => [
        transactions,
        categories,
        totalExpense,
        totalIncome,
        isSyncing,
        nickname,
        budgetLimit,
      ];
}

class ExpenseError extends ExpenseState {
  final String message;

  const ExpenseError(this.message);

  @override
  List<Object> get props => [message];
}

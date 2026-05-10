import 'package:dartz/dartz.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';

abstract class ExpenseRepository {
  Future<Either<String, List<CategoryModel>>> getCategories();
  Future<Either<String, void>> addCategory(CategoryModel category);
  Future<Either<String, void>> deleteCategory(String id);

  Future<Either<String, List<TransactionModel>>> getTransactions();
  Future<Either<String, void>> addTransaction(TransactionModel transaction);
  Future<Either<String, void>> deleteTransaction(String id);

  Future<Either<String, void>> syncData();
  
  // Custom query for notifications
  Future<double> getCurrentMonthDebits();
}

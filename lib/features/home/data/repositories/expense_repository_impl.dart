import 'package:dartz/dartz.dart';
import '../../../../core/services/notification_service.dart';
import '../../data/datasources/expense_local_datasource.dart';
import '../../data/datasources/expense_remote_datasource.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';
import '../../domain/repositories/expense_repository.dart';

class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseLocalDataSource localDataSource;
  final ExpenseRemoteDataSource remoteDataSource;
  final NotificationService notificationService;

  ExpenseRepositoryImpl({
    required this.localDataSource,
    required this.remoteDataSource,
    required this.notificationService,
  });

  @override
  Future<Either<String, List<CategoryModel>>> getCategories() async {
    try {
      final categories = await localDataSource.getCategories(includeDeleted: false);
      return Right(categories);
    } catch (e) {
      return Left('Local Database Error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> addCategory(CategoryModel category) async {
    try {
      await localDataSource.addCategory(category);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteCategory(String id) async {
    try {
      await localDataSource.deleteCategory(id);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, List<TransactionModel>>> getTransactions() async {
    try {
      final transactions = await localDataSource.getTransactions(includeDeleted: false);
      return Right(transactions);
    } catch (e) {
      return Left('Local Database Error: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> addTransaction(TransactionModel transaction) async {
    try {
      await localDataSource.addTransaction(transaction);
      
      // Budget Limit Check Logic
      if (transaction.type == 'debit') {
        final totalDebit = await getCurrentMonthDebits();
        const double limit = 1000.0;
        
        // Only trigger notification the exact moment it crosses the threshold
        if (totalDebit > limit && (totalDebit - transaction.amount) <= limit) {
          await notificationService.showBudgetAlertNotification(totalDebit, limit);
        }
      }
      
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, void>> deleteTransaction(String id) async {
    try {
      await localDataSource.deleteTransaction(id);
      return const Right(null);
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<double> getCurrentMonthDebits() async {
    try {
      final transactions = await localDataSource.getTransactions(includeDeleted: false);
      final now = DateTime.now();
      
      double total = 0;
      for (final tx in transactions) {
        if (tx.type == 'debit' && 
            tx.timestamp.year == now.year && 
            tx.timestamp.month == now.month) {
          total += tx.amount;
        }
      }
      return total;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Future<Either<String, void>> syncData() async {
    try {
      // --- STEP A: Cloud Purge ---
      
      // 1. Delete Transactions
      final deletedTxs = await localDataSource.getDeletedTransactions();
      if (deletedTxs.isNotEmpty) {
        final deletedIds = await remoteDataSource.deleteTransactions(deletedTxs.map((e) => e.id).toList());
        for (final id in deletedIds) {
          await localDataSource.hardDeleteTransaction(id);
        }
      }

      // 2. Delete Categories
      final deletedCats = await localDataSource.getDeletedCategories();
      if (deletedCats.isNotEmpty) {
        final deletedIds = await remoteDataSource.deleteCategories(deletedCats.map((e) => e.id).toList());
        for (final id in deletedIds) {
          await localDataSource.hardDeleteCategory(id);
        }
      }

      // --- STEP B: Cloud Backup ---
      
      // 1. Sync Categories First
      final unsyncedCats = await localDataSource.getUnsyncedCategories();
      if (unsyncedCats.isNotEmpty) {
        for (final category in unsyncedCats) {
          // The API add category expects a single object per request
          try {
            final syncedIds = await remoteDataSource.addCategory(category);
            await localDataSource.markCategorySynced(syncedIds);
          } catch (_) {
            // Continue with others if one fails
          }
        }
      }

      // 2. Sync Transactions Second (Batch)
      final unsyncedTxs = await localDataSource.getUnsyncedTransactions();
      if (unsyncedTxs.isNotEmpty) {
        final syncedIds = await remoteDataSource.addTransactions(unsyncedTxs);
        await localDataSource.markTransactionSynced(syncedIds);
      }

      return const Right(null);
    } catch (e) {
      return Left('Sync failed: ${e.toString()}');
    }
  }
}

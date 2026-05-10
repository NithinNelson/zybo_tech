import 'dart:developer';

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
      
      if (transaction.type == 'debit') {
        final totalDebit = await getCurrentMonthDebits();
        const double limit = 1000.0;
        
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
      final deletedTxs = await localDataSource.getDeletedTransactions();
      if (deletedTxs.isNotEmpty) {
        final deletedIds = await remoteDataSource.deleteTransactions(deletedTxs.map((e) => e.id).toList());
        for (final id in deletedIds) {
          await localDataSource.hardDeleteTransaction(id);
        }
      }

      final deletedCats = await localDataSource.getDeletedCategories();
      if (deletedCats.isNotEmpty) {
        final deletedIds = await remoteDataSource.deleteCategories(deletedCats.map((e) => e.id).toList());
        for (final id in deletedIds) {
          await localDataSource.hardDeleteCategory(id);
        }
      }

      final unsyncedCats = await localDataSource.getUnsyncedCategories();
      if (unsyncedCats.isNotEmpty) {
        for (final category in unsyncedCats) {
          try {
            final syncedIds = await remoteDataSource.addCategory(category);
            await localDataSource.markCategorySynced(syncedIds);
          } catch (_) {}
        }
      }

      final unsyncedTxs = await localDataSource.getUnsyncedTransactions();
      if (unsyncedTxs.isNotEmpty) {
        final syncedIds = await remoteDataSource.addTransactions(unsyncedTxs);
        await localDataSource.markTransactionSynced(syncedIds);
      }

      final remoteCategories = await remoteDataSource.getCategories();
      for (final cat in remoteCategories) {
        await localDataSource.addCategory(cat.copyWith(isSynced: true));
      }

      final allLocalCats = await localDataSource.getCategories(includeDeleted: false);
      final catNameToId = <String, String>{};
      for (final c in allLocalCats) {
        catNameToId[c.name] = c.id;
      }

      final remoteTransactions = await remoteDataSource.getTransactions();
      for (final tx in remoteTransactions) {
        final resolvedCatId = (tx.categoryId.isNotEmpty) ? tx.categoryId : (catNameToId[tx.categoryName] ?? '');
        await localDataSource.addTransaction(tx.copyWith(isSynced: true, categoryId: resolvedCatId));
      }

      return const Right(null);
    } catch (e) {
      return Left('Sync failed: ${e.toString()}');
    }
  }

  @override
  Future<Either<String, void>> fetchInitialData() async {
    try {
      final remoteCategories = await remoteDataSource.getCategories();
      final localCategories = await localDataSource.getCategories(includeDeleted: true);
      final localCategoryIds = localCategories.map((c) => c.id).toSet();
      log('--------remoteCategories--------${remoteCategories.length}');

      for (final cat in remoteCategories) {
        if (!localCategoryIds.contains(cat.id)) {
          await localDataSource.addCategory(cat.copyWith(isSynced: true));
        }
      }

      // Build a name→id map so we can resolve API category names to local UUIDs
      final allLocalCats = await localDataSource.getCategories(includeDeleted: false);
      final catNameToId = <String, String>{};
      for (final c in allLocalCats) {
        catNameToId[c.name] = c.id;
      }

      final remoteTransactions = await remoteDataSource.getTransactions();
      final localTransactions = await localDataSource.getTransactions(includeDeleted: true);
      final localTransactionIds = localTransactions.map((t) => t.id).toSet();

      for (final tx in remoteTransactions) {
        if (!localTransactionIds.contains(tx.id)) {
          final resolvedCatId = (tx.categoryId.isNotEmpty) ? tx.categoryId : (catNameToId[tx.categoryName] ?? '');
          await localDataSource.addTransaction(tx.copyWith(isSynced: true, categoryId: resolvedCatId));
        }
      }

      return const Right(null);
    } catch (e) {
      return Left('Initial fetch failed: ${e.toString()}');
    }
  }
}

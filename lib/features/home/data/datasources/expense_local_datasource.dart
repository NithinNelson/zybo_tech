import 'package:sqflite/sqflite.dart';
import '../../../../core/database/database_helper.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

abstract class ExpenseLocalDataSource {
  Future<List<CategoryModel>> getCategories({bool includeDeleted = false});
  Future<void> addCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
  Future<void> hardDeleteCategory(String id);
  Future<void> markCategorySynced(List<String> ids);

  Future<List<TransactionModel>> getTransactions({bool includeDeleted = false});
  Future<void> addTransaction(TransactionModel transaction);
  Future<void> deleteTransaction(String id);
  Future<void> hardDeleteTransaction(String id);
  Future<void> markTransactionSynced(List<String> ids);
  
  Future<List<CategoryModel>> getUnsyncedCategories();
  Future<List<CategoryModel>> getDeletedCategories();
  Future<List<TransactionModel>> getUnsyncedTransactions();
  Future<List<TransactionModel>> getDeletedTransactions();
}

class ExpenseLocalDataSourceImpl implements ExpenseLocalDataSource {
  final DatabaseHelper databaseHelper;

  ExpenseLocalDataSourceImpl({required this.databaseHelper});

  @override
  Future<List<CategoryModel>> getCategories({bool includeDeleted = false}) async {
    final db = await databaseHelper.database;
    final where = includeDeleted ? null : 'is_deleted = 0';
    final List<Map<String, dynamic>> maps = await db.query(
      'categories',
      where: where,
    );
    return List.generate(maps.length, (i) => CategoryModel.fromJson(maps[i]));
  }

  @override
  Future<void> addCategory(CategoryModel category) async {
    final db = await databaseHelper.database;
    await db.insert(
      'categories',
      category.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
    final db = await databaseHelper.database;
    await db.update(
      'categories',
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<void> hardDeleteCategory(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'categories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markCategorySynced(List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await databaseHelper.database;
    await db.update(
      'categories',
      {'is_synced': 1},
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }

  @override
  Future<List<TransactionModel>> getTransactions({bool includeDeleted = false}) async {
    final db = await databaseHelper.database;
    final where = includeDeleted ? '' : 'WHERE t.is_deleted = 0';
    
    final query = '''
      SELECT 
        t.*, 
        c.name as category_name
      FROM transactions t
      LEFT JOIN categories c ON t.category_id = c.id
      $where
      ORDER BY t.timestamp DESC
    ''';
    
    final List<Map<String, dynamic>> maps = await db.rawQuery(query);
    return List.generate(maps.length, (i) => TransactionModel.fromJson(maps[i]));
  }

  @override
  Future<void> addTransaction(TransactionModel transaction) async {
    final db = await databaseHelper.database;
    await db.insert(
      'transactions',
      transaction.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await databaseHelper.database;
    await db.update(
      'transactions',
      {'is_deleted': 1, 'is_synced': 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  
  @override
  Future<void> hardDeleteTransaction(String id) async {
    final db = await databaseHelper.database;
    await db.delete(
      'transactions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<void> markTransactionSynced(List<String> ids) async {
    if (ids.isEmpty) return;
    final db = await databaseHelper.database;
    await db.update(
      'transactions',
      {'is_synced': 1},
      where: 'id IN (${List.filled(ids.length, '?').join(',')})',
      whereArgs: ids,
    );
  }

  @override
  Future<List<CategoryModel>> getUnsyncedCategories() async {
    final db = await databaseHelper.database;
    final maps = await db.query('categories', where: 'is_synced = 0 AND is_deleted = 0');
    return List.generate(maps.length, (i) => CategoryModel.fromJson(maps[i]));
  }

  @override
  Future<List<CategoryModel>> getDeletedCategories() async {
    final db = await databaseHelper.database;
    final maps = await db.query('categories', where: 'is_deleted = 1');
    return List.generate(maps.length, (i) => CategoryModel.fromJson(maps[i]));
  }

  @override
  Future<List<TransactionModel>> getUnsyncedTransactions() async {
    final db = await databaseHelper.database;
    final maps = await db.query('transactions', where: 'is_synced = 0 AND is_deleted = 0');
    return List.generate(maps.length, (i) => TransactionModel.fromJson(maps[i]));
  }

  @override
  Future<List<TransactionModel>> getDeletedTransactions() async {
    final db = await databaseHelper.database;
    final maps = await db.query('transactions', where: 'is_deleted = 1');
    return List.generate(maps.length, (i) => TransactionModel.fromJson(maps[i]));
  }
}

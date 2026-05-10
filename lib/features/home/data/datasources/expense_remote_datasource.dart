import 'dart:convert';
import '../../../../core/network/api_client.dart';
import '../models/category_model.dart';
import '../models/transaction_model.dart';

abstract class ExpenseRemoteDataSource {
  // Categories
  Future<List<CategoryModel>> getCategories();
  Future<List<String>> addCategory(CategoryModel category); // Return synced IDs
  Future<List<String>> deleteCategories(List<String> ids); // Return deleted IDs

  // Transactions
  Future<List<TransactionModel>> getTransactions();
  Future<List<String>> addTransactions(List<TransactionModel> transactions); // Return synced IDs
  Future<List<String>> deleteTransactions(List<String> ids); // Return deleted IDs
}

class ExpenseRemoteDataSourceImpl implements ExpenseRemoteDataSource {
  final ApiClient apiClient;

  ExpenseRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiClient.get('/categories/');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final List<dynamic> categoriesJson = data['categories'];
        return categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
      }
    }
    throw Exception('Failed to get categories');
  }

  @override
  Future<List<String>> addCategory(CategoryModel category) async {
    final response = await apiClient.post(
      '/categories/add/',
      body: category.toApiJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<String>.from(data['synced_ids']);
      }
    }
    throw Exception('Failed to add category');
  }

  @override
  Future<List<String>> deleteCategories(List<String> ids) async {
    if (ids.isEmpty) return [];
    final response = await apiClient.delete(
      '/categories/delete/',
      body: {'ids': ids},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<String>.from(data['deleted_ids']);
      }
    }
    throw Exception('Failed to delete categories');
  }

  @override
  Future<List<TransactionModel>> getTransactions() async {
    final response = await apiClient.get('/transactions/');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        final List<dynamic> transactionsJson = data['transactions'];
        return transactionsJson.map((json) => TransactionModel.fromJson(json)).toList();
      }
    }
    throw Exception('Failed to get transactions');
  }

  @override
  Future<List<String>> addTransactions(List<TransactionModel> transactions) async {
    if (transactions.isEmpty) return [];
    
    final response = await apiClient.post(
      '/transactions/add/',
      body: {
        'transactions': transactions.map((t) => t.toApiJson()).toList(),
      },
    );
    
    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<String>.from(data['synced_ids']);
      }
    }
    throw Exception('Failed to batch add transactions');
  }

  @override
  Future<List<String>> deleteTransactions(List<String> ids) async {
    if (ids.isEmpty) return [];
    final response = await apiClient.delete(
      '/transactions/delete/',
      body: {'ids': ids},
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == 'success') {
        return List<String>.from(data['deleted_ids']);
      }
    }
    throw Exception('Failed to delete transactions');
  }
}

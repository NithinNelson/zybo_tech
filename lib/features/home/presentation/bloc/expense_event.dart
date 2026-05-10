import 'package:equatable/equatable.dart';
import '../../data/models/category_model.dart';
import '../../data/models/transaction_model.dart';

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardEvent extends ExpenseEvent {}

class AddTransactionEvent extends ExpenseEvent {
  final TransactionModel transaction;

  const AddTransactionEvent(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class DeleteTransactionEvent extends ExpenseEvent {
  final String id;

  const DeleteTransactionEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddCategoryEvent extends ExpenseEvent {
  final CategoryModel category;

  const AddCategoryEvent(this.category);

  @override
  List<Object> get props => [category];
}

class DeleteCategoryEvent extends ExpenseEvent {
  final String id;

  const DeleteCategoryEvent(this.id);

  @override
  List<Object> get props => [id];
}

class SyncDataEvent extends ExpenseEvent {}

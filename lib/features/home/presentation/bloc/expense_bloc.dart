import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/expense_repository.dart';
import '../../../../features/auth/domain/repositories/auth_repository.dart';
import 'expense_event.dart';
import 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final ExpenseRepository repository;
  final AuthRepository authRepository;

  ExpenseBloc({
    required this.repository,
    required this.authRepository,
  }) : super(ExpenseInitial()) {
    on<LoadDashboardEvent>(_onLoadDashboard);
    on<AddTransactionEvent>(_onAddTransaction);
    on<DeleteTransactionEvent>(_onDeleteTransaction);
    on<AddCategoryEvent>(_onAddCategory);
    on<DeleteCategoryEvent>(_onDeleteCategory);
    on<SyncDataEvent>(_onSyncData);
    on<FetchInitialDataEvent>(_onFetchInitialData);
    on<SetBudgetLimitEvent>(_onSetBudgetLimit);
  }

  Future<void> _onLoadDashboard(LoadDashboardEvent event, Emitter<ExpenseState> emit) async {
    emit(ExpenseLoading());
    await _loadData(emit);
  }

  Future<void> _loadData(Emitter<ExpenseState> emit, {bool isSyncing = false}) async {
    final transactionsResult = await repository.getTransactions();
    final categoriesResult = await repository.getCategories();
    final nickname = await authRepository.getNickname() ?? '';
    final budgetLimit = await authRepository.getBudgetLimit();

    transactionsResult.fold(
      (error) => emit(ExpenseError(error)),
      (transactions) {
        categoriesResult.fold(
          (error) => emit(ExpenseError(error)),
          (categories) {
            double totalExpense = 0;
            double totalIncome = 0;
            
            for (var tx in transactions) {
              if (tx.type == 'debit') {
                totalExpense += tx.amount;
              } else if (tx.type == 'credit') {
                totalIncome += tx.amount;
              }
            }

            emit(ExpenseLoaded(
              transactions: transactions,
              categories: categories,
              totalExpense: totalExpense,
              totalIncome: totalIncome,
              isSyncing: isSyncing,
              nickname: nickname,
              budgetLimit: budgetLimit,
            ));
          },
        );
      },
    );
  }

  Future<void> _onAddTransaction(AddTransactionEvent event, Emitter<ExpenseState> emit) async {
    final result = await repository.addTransaction(event.transaction);

    if (result.isLeft()) {
      result.fold((error) => emit(ExpenseError(error)), (_) {});
    } else {
      await _loadData(emit);
    }
  }

  Future<void> _onDeleteTransaction(DeleteTransactionEvent event, Emitter<ExpenseState> emit) async {
    if (state is ExpenseLoaded) {
      final currentState = state as ExpenseLoaded;
      final updatedList = currentState.transactions.where((t) => t.id != event.id).toList();

      double newTotalExpense = 0;
      double newTotalIncome = 0;
      for (var tx in updatedList) {
        if (tx.type == 'debit') {
          newTotalExpense += tx.amount;
        } else if (tx.type == 'credit') {
          newTotalIncome += tx.amount;
        }
      }

      if (!emit.isDone) {
        emit(currentState.copyWith(
          transactions: updatedList,
          totalExpense: newTotalExpense,
          totalIncome: newTotalIncome,
        ));
      }
    }

    final result = await repository.deleteTransaction(event.id);

    if (result.isLeft()) {
      result.fold((error) => emit(ExpenseError(error)), (_) {});
    } else {
      await _loadData(emit);
    }
  }

  Future<void> _onAddCategory(AddCategoryEvent event, Emitter<ExpenseState> emit) async {
    final result = await repository.addCategory(event.category);
    if (result.isLeft()) {
      result.fold((error) => emit(ExpenseError(error)), (_) {});
    } else {
      await _loadData(emit);
    }
  }

  Future<void> _onDeleteCategory(DeleteCategoryEvent event, Emitter<ExpenseState> emit) async {
    if (state is ExpenseLoaded) {
      final currentState = state as ExpenseLoaded;
      final updatedCategories = currentState.categories.where((c) => c.id != event.id).toList();
      emit(currentState.copyWith(categories: updatedCategories));
    }
    
    final result = await repository.deleteCategory(event.id);
    if (result.isLeft()) {
      result.fold((error) => emit(ExpenseError(error)), (_) {});
    } else {
      await _loadData(emit);
    }
  }

  Future<void> _onSyncData(SyncDataEvent event, Emitter<ExpenseState> emit) async {
    if (state is ExpenseLoaded) {
      final currentState = state as ExpenseLoaded;
      if (!emit.isDone) emit(currentState.copyWith(isSyncing: true));
    }

    final result = await repository.syncData();

    if (result.isLeft()) {
      String? error;
      result.fold((l) => error = l, (r) {});
      if (error != null && !emit.isDone) emit(ExpenseError(error!));
    }

    await _loadData(emit);
  }

  Future<void> _onFetchInitialData(FetchInitialDataEvent event, Emitter<ExpenseState> emit) async {
    if (state is ExpenseLoaded) {
      final currentState = state as ExpenseLoaded;
      if (!emit.isDone) emit(currentState.copyWith(isSyncing: true));
    } else {
      if (!emit.isDone) emit(ExpenseLoading());
    }
    
    final result = await repository.fetchInitialData();
    
    if (result.isLeft()) {
      String? error;
      result.fold((l) => error = l, (r) {});
      if (error != null && !emit.isDone) emit(ExpenseError(error!));
    }
    
    await _loadData(emit);
  }

  Future<void> _onSetBudgetLimit(SetBudgetLimitEvent event, Emitter<ExpenseState> emit) async {
    await authRepository.saveBudgetLimit(event.limit);
    await _loadData(emit);
  }
}

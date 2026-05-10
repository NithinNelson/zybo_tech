import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:http/http.dart' as http;
import 'core/database/database_helper.dart';
import 'core/network/api_client.dart';
import 'core/services/notification_service.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/home/data/datasources/expense_local_datasource.dart';
import 'features/home/data/datasources/expense_remote_datasource.dart';
import 'features/home/data/repositories/expense_repository_impl.dart';
import 'features/home/domain/repositories/expense_repository.dart';
import 'features/home/presentation/bloc/expense_bloc.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Blocs
  sl.registerFactory(() => OnboardingBloc(repository: sl()));
  sl.registerFactory(() => AuthBloc(repository: sl()));
  sl.registerFactory(() => ExpenseBloc(repository: sl(), authRepository: sl()));

  // Repositories
  sl.registerLazySingleton<OnboardingRepository>(
    () => OnboardingRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), sharedPreferences: sl()),
  );
  sl.registerLazySingleton<ExpenseRepository>(
    () => ExpenseRepositoryImpl(
      localDataSource: sl(),
      remoteDataSource: sl(),
      notificationService: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<OnboardingLocalDataSource>(
    () => OnboardingLocalDataSourceImpl(sharedPreferences: sl()),
  );
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<ExpenseLocalDataSource>(
    () => ExpenseLocalDataSourceImpl(databaseHelper: sl()),
  );
  sl.registerLazySingleton<ExpenseRemoteDataSource>(
    () => ExpenseRemoteDataSourceImpl(apiClient: sl()),
  );

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Core Services
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => ApiClient(sharedPreferences: sl(), client: sl()));
  
  final databaseHelper = DatabaseHelper.instance;
  sl.registerLazySingleton(() => databaseHelper);

  final notificationService = NotificationService();
  await notificationService.init();
  sl.registerLazySingleton(() => notificationService);
}

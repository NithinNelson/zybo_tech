import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_datasource.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, bool>> isFirstTime() async {
    try {
      final result = await localDataSource.isFirstTime();
      return Right(result);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, void>> setFirstTimeCompleted() async {
    try {
      await localDataSource.setFirstTimeCompleted();
      return const Right(null);
    } catch (e) {
      return const Left(CacheFailure());
    }
  }
}

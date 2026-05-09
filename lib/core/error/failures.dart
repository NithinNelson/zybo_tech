import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = 'An unexpected error occurred']);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Failed to load from cache']);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Failed to connect to server']);
}

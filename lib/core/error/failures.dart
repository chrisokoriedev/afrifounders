import 'package:equatable/equatable.dart';

/// Base failure class for error handling
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

/// Failure for cache/local storage errors
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// Failure for network errors
class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

/// Failure for validation errors
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// Failure for unknown errors
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}


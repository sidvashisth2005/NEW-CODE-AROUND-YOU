import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
}

class ServerFailure extends Failure {
  const ServerFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class CacheFailure extends Failure {
  const CacheFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class AuthFailure extends Failure {
  const AuthFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class LocationFailure extends Failure {
  const LocationFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class PermissionFailure extends Failure {
  const PermissionFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    required String message,
    int? code,
  }) : super(message: message, code: code);
}

// Extension for converting exceptions to failures
extension ExceptionToFailure on Exception {
  Failure toFailure() {
    if (this is NetworkException) {
      return NetworkFailure(
        message: (this as NetworkException).message,
        code: (this as NetworkException).code,
      );
    } else if (this is ServerException) {
      return ServerFailure(
        message: (this as ServerException).message,
        code: (this as ServerException).code,
      );
    } else if (this is AuthException) {
      return AuthFailure(
        message: (this as AuthException).message,
        code: (this as AuthException).code,
      );
    } else if (this is LocationException) {
      return LocationFailure(
        message: (this as LocationException).message,
        code: (this as LocationException).code,
      );
    } else if (this is ValidationException) {
      return ValidationFailure(
        message: (this as ValidationException).message,
        code: (this as ValidationException).code,
      );
    } else if (this is PermissionException) {
      return PermissionFailure(
        message: (this as PermissionException).message,
        code: (this as PermissionException).code,
      );
    } else {
      return UnknownFailure(
        message: toString(),
      );
    }
  }
}

// Custom exceptions
class NetworkException implements Exception {
  final String message;
  final int? code;
  
  const NetworkException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'NetworkException: $message (Code: $code)';
}

class ServerException implements Exception {
  final String message;
  final int? code;
  
  const ServerException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'ServerException: $message (Code: $code)';
}

class AuthException implements Exception {
  final String message;
  final int? code;
  
  const AuthException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

class LocationException implements Exception {
  final String message;
  final int? code;
  
  const LocationException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'LocationException: $message (Code: $code)';
}

class ValidationException implements Exception {
  final String message;
  final int? code;
  
  const ValidationException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'ValidationException: $message (Code: $code)';
}

class PermissionException implements Exception {
  final String message;
  final int? code;
  
  const PermissionException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'PermissionException: $message (Code: $code)';
}

class CacheException implements Exception {
  final String message;
  final int? code;
  
  const CacheException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'CacheException: $message (Code: $code)';
}
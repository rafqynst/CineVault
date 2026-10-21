class AppException implements Exception {
  final String message;

  const AppException(this.message);

  @override
  String toString() => message;
}

class PermissionDeniedException extends AppException {
  const PermissionDeniedException()
      : super('Permission denied.');
}

class MediaStoreException extends AppException {
  const MediaStoreException(String message)
      : super(message);
}

class DatabaseException extends AppException {
  const DatabaseException(String message)
      : super(message);
}
class ServerException implements Exception {
  final String errorMessage;

  const ServerException({required this.errorMessage});
}

class DataBaseException implements Exception {
  final String errorMessage;

  const DataBaseException({required this.errorMessage});
}

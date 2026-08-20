/// Excepciones de dominio para la capa de red/negocio de AgroTareo AGK.
class AppException implements Exception {
  const AppException(this.message);

  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'Sin conexion con el servidor. Verifica tu red.']);
}

class TimeoutExceptionApp extends AppException {
  const TimeoutExceptionApp([super.message = 'El servidor no respondio a tiempo. Intenta nuevamente.']);
}

class AuthException extends AppException {
  const AuthException([super.message = 'Usuario o contrasena incorrectos.']);
}

class ServerException extends AppException {
  const ServerException(super.message, {this.statusCode});

  final int? statusCode;
}

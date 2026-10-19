abstract class Failure {
  final String message;
  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Error en el servidor de base de datos']);
}

class ConnectionFailure extends Failure {
  const ConnectionFailure([super.message = 'Sin conexión a internet']);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'Ha ocurrido un error inesperado']);
}
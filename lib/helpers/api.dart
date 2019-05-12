/// Módulo para el desarrollo de clases, excepciones y funciones
/// auxiliares para el manejo de la API y de los servicios de conexión
/// con el servidor.

import 'package:http/http.dart' as http;

/// Cliente HTTP para realizar conexiones con el servidor, extendido
/// para permitir el envío de un token JWT en la cabecera de cada
/// petición.
class UserAgentClient extends http.BaseClient {
  final String userAgent;
  final http.Client _inner;
  final String _token;

  UserAgentClient(this.userAgent, this._inner, this._token);

  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers['Authorization'] = "Bearer " + this._token;
    return _inner.send(request);
  }
}

/// Excepción personalizada para manejar errores retornados
/// por el servidor, incluyendo el mensaje de detalles y,
/// opcionalmente, el código de la petición.
class APIException implements Exception {

  final String details;
  int code;

  APIException(this.details, {this.code});

  String toString() => "APIException: $details";
}
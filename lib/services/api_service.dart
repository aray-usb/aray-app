/// Módulo para el desarrollo de un proveedor de servicios para permitir
/// la conexión y comunicación entre la aplicación y la API.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aray/env.dart';
import 'package:aray/helpers/api.dart';

/// Proveedor de servicios para manejar la conexión entre la
/// aplicación y la API de Aray.
class APIService {

  static final apiBaseUrl = ENV['API_BASE_URL'];
  String apiToken;
  UserAgentClient client;

  /// Constructor del servicio de conexión con la API. Obtiene (o guarda) un token
  /// JWT de autenticación, y genera una instancia del cliente de conexión autenticado.
  APIService({this.apiToken}) {
    // Como al instanciar el servicio tenemos que obtener un token
    // para instanciar al cliente (si este no es obtenido), y esto
    // se realiza de manera asíncrona, lo hacemos en un método aparte
    initClient();
  }

  /// Inicializa un cliente autenticado para la conexión con la API.
  void initClient() async {
    // Verificamos si el token ya ha sido obtenido
    if (this.apiToken != null) {
      this.apiToken = await this.getToken();
    }

    // Instanciamos el cliente
    this.client = UserAgentClient("Aray API mobile service provider", http.Client(), this.apiToken);
  }

  /// Verifica que el código de respuesta del servidor sea válido; en caso
  /// de no serlo, arroja una excepción con el mensaje correspondiente.
  void validateResponse(statusCode, responseBody) {
    if (200 < statusCode || statusCode >= 300) {
      throw APIException(responseBody['details'], code: statusCode);
    }
  }

  /// Solicita un token de autenticación válido para la conexión con el servidor.
  Future<String> getToken() async {
    final url = APIService.apiBaseUrl + 'tokens/get/';

    try {
      // TODO: Utilizar credenciales de autenticación del usuario
      final response = await http.post(
        url,
        body: {
          'username': ENV['API_USERNAME'],
          'password': ENV['API_PASSWORD']
        }
      );

      dynamic responseJson = json.decode(response.body);
      validateResponse(response.statusCode, responseJson);

      String token = responseJson['token'];
      return token;
    } catch (e) {
      // TODO: Mejorar el manejo de errores del servicio.
      print(e);
      throw e;
    }
  }

}

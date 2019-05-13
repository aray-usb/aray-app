/// Módulo para el desarrollo de un proveedor de servicios para permitir
/// la conexión y comunicación entre la aplicación y la API.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:aray/env.dart';
import 'package:aray/helpers/api.dart';
import 'package:aray/models/reporte.dart';

/// Proveedor de servicios para manejar la conexión entre la
/// aplicación y la API de Aray.
class APIService {

  // URL base de la API, sacada del entorno
  static final apiBaseUrl = ENV['API_BASE_URL'];

  // Token de autenticación para la API
  String apiToken;

  // Cliente autenticado para conexión con la API.
  UserAgentClient client;

  /// Inicializa un cliente autenticado para la conexión con la API.
  /// Como al instanciar el servicio tenemos que obtener un token
  /// para instanciar al cliente (si este no es obtenido), y esto
  /// se realiza de manera asíncrona, lo hacemos en un método aparte.
  /// Este método puede ser llamad múltiples veces con seguridad.
  Future<void> initClient() async {
    // Verificamos si el token ya ha sido obtenido
    if (this.client == null) {
      this.apiToken = await this.getToken();

      // Instanciamos el cliente
      this.client = UserAgentClient("ArayAPP", http.Client(), this.apiToken);
      return true;
    }

    return false;
  }

  /// Verifica que el código de respuesta del servidor sea válido; en caso
  /// de no serlo, arroja una excepción con el mensaje correspondiente.
  void validateResponse(statusCode, responseBody) {
    if (200 < statusCode || statusCode >= 300) {
      throw APIException(responseBody['detail'], code: statusCode);
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

      // Parseamos la respuesta como JSON
      dynamic responseJson = json.decode(response.body);
      validateResponse(response.statusCode, responseJson);

      // Obtenemos el token
      String token = responseJson['token'];
      return token;
    } catch (e) {
      // TODO: Mejorar el manejo de errores del servicio.
      print(e);
      throw e;
    }
  }

  /// Retorna una lista de reportes, opcionalmente centrados en la
  /// ubicación pasada com parámetro
  Future<List<Reporte>> getReportes({LatLng position}) async {
    String url = APIService.apiBaseUrl + 'reportes/';

    // Si se recibe un LatLng, centramos la petición en esta ubicación
    if (position != null) {
      url += "?lat=${position.latitude}&long=${position.longitude}";
      url = Uri.encodeFull(url);
    }

    try {
      // Esperamos la inicialización del cliente
      await initClient();
      final response = await this.client.get(url);
      dynamic jsonObject = json.decode(response.body);
      validateResponse(response.statusCode, jsonObject);

      // Utilizamos el constructor a partir de una lista JSON de Reporte
      // para retornar la lista
      return Reporte.fromJsonList(jsonObject);
    } catch (e) {
      // TODO: Mejorar el manejo de errores del servicio.
      print(e);
      throw e;
    }
  }

}

/// Módulo para el desarrollo de un proveedor de servicios para permitir
/// la conexión y comunicación entre la aplicación y la API.

import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:latlong/latlong.dart';
import 'package:aray/env.dart';
import 'package:aray/helpers/api.dart';
import 'package:aray/models/reporte.dart';
import 'package:aray/models/incidencia.dart';
import 'package:aray/models/tarea.dart';


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
    if (this.client == null || this.apiToken == null) {
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

  /// Retorna un token de autenticación válido para la conexión con el servidor
  /// o genera un error en caso de que sea inválido.
  Future<String> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      // TODO: Consider token validity
      final String token = prefs.getString('token');

      if (token == null) {
        throw AuthException("No existe un token almacenado en el dispositivo.");
      }
      return token;
    } catch (e) {
      // TODO: Improve exception handling
      throw AuthException("No existe un token almacenado en el dispositivo.");
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

  /// Retorna una lista de incidencias registradas en la aplicación
  Future<List<Incidencia>> getIncidencias() async {
    String url = APIService.apiBaseUrl + 'incidencias/';

    try {
      // Esperamos la inicialización del cliente
      await initClient();
      final response = await this.client.get(url);
      dynamic jsonObject = json.decode(response.body);
      validateResponse(response.statusCode, jsonObject);

      // Utilizamos el constructor a partir de una lista JSON de Incidencia
      // para retornar la lista
      return Incidencia.fromJsonList(jsonObject);
    } catch (e) {
      // TODO: Mejorar el manejo de errores del servicio.
      print(e);
      throw e;
    }
  }

  /// Retorna una lista de tareas registradas en la aplicación
  Future<List<Tarea>> getTareas() async {
    String url = APIService.apiBaseUrl + 'tareas/';

      // Esperamos la inicialización del cliente
      await initClient();
      final response = await this.client.get(url);
      dynamic jsonObject = json.decode(response.body);
      validateResponse(response.statusCode, jsonObject);

      // Utilizamos el constructor a partir de una lista JSON de Tarea
      // para retornar la lista
      return Tarea.fromJsonList(jsonObject);
  }

  /// Crea un nuevo reporte en la plataforma
  Future<dynamic> createReporte(
    latitud,
    longitud,
    incidenciaId,
    contenido,
    esAyuda
  ) async {
    String url = APIService.apiBaseUrl + 'reportes/';

      // Esperamos la inicialización del cliente
      await initClient();
      final response = await this.client.post(
        url,
        body: {
          'latitud': latitud.toString(),
          'longitud': longitud.toString(),
          'incidencia_id': incidenciaId.toString(),
          'contenido': contenido,
          'es_solicitud_de_ayuda': esAyuda.toString(),
        }
      );

      return json.decode(response.body);
  }

  /// Crea una nueva tarea en la plataforma
  Future<dynamic> createTarea(
    titulo,
    descripcion,
    fechaLimite
  ) async {
    String url = APIService.apiBaseUrl + 'tareas/';

      // Esperamos la inicialización del cliente
      await initClient();
      final response = await this.client.post(
        url,
        body: {
          'titulo': titulo.toString(),
          'descripcion': descripcion.toString(),
          'fecha_limite': fechaLimite.toString(),
        }
      );

      return json.decode(response.body);
  }

  /// Actualiza el estado de una tarea en la plataforma
  Future<dynamic> updateTask(
    id,
    newState
  ) async {
    String url = APIService.apiBaseUrl + 'actualizar-tarea/';

      // Esperamos la inicialización del cliente
      await initClient();
      final response = await this.client.post(
        url,
        body: {
          'id': id.toString(),
          'estado': newState.toString(),
        }
      );

      print(response.body);

      return json.decode(response.body);
  }
}

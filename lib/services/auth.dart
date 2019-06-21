/// Módulo para el desarrollo de un proveedor de servicios para permitir
/// la autenticación de la aplicación con el servidor a través de la API no autenticada.

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aray/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Proveedor de servicios para autenticación inicial con el
/// backend del servidor de Aray.
class AuthService {

  // URL base de la API, sacada del entorno
  static final apiBaseUrl = ENV['API_BASE_URL'];

  /// Dados los datos de un usuario, registra el usuario en el servidor
  Future<bool> registerUser(
    String username,
    String password,
    String email,
    String firstName,
    String lastName,
    String phone,
    String document
  ) async {
    final url = AuthService.apiBaseUrl + 'registro/';

    try {
      // Emitimos la petición con las credenciales pasadas
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'phone': phone,
          'document': document,
        }
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        // TODO: Handle custom exception
        return false;
      }

      return true;
    } catch (e) {
      // TODO: Handle custom exception
      print(e);
      throw e;
    }

  }

  /// Dados un nombre de usuario y contraseña, permite obtener y almacenar
  /// en el localStorage un token de autenticación.
  Future<String> getToken(String username, String password) async {
    final url = AuthService.apiBaseUrl + 'tokens/get/';

    try {
      // Emitimos la petición con las credenciales pasadas
      final response = await http.post(
        url,
        body: {
          'username': username,
          'password': password,
        }
      );

      // Parseamos la respuesta como json
      dynamic responseJson = json.decode(response.body);
      if (response.statusCode != 200) {
        // TODO: Handle custom exception
        return null;
      }

      // Obtenemos el token y almacenamos en LocalStorage
      String token = responseJson['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', token);
      prefs.setString('username', username);
      return token;
    } catch (e) {
      // TODO: Handle custom exception
      print(e);
      throw e;
    }
  }

  /// Dado un token de autenticación, intenta verificar que el token
  /// sea válido con el servidor.
  Future<bool> verifyToken(String token) async {
    final url = AuthService.apiBaseUrl + 'tokens/verify/';

    try {
      // Emitimos la petición con las credenciales pasadas
      final response = await http.post(
        url,
        body: {
          'token': token,
        }
      );

      // El código de respuesta nos permite determinar si es válido o no
      return response.statusCode == 200;
    } catch (e) {
      // TODO: Handle custom exception
      print(e);
      throw e;
    }
  }
}
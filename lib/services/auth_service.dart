import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  // Auth móvil: El token Bearer se guarda localmente para usarlo en requests autenticados
  Future<void> _saveSession(AuthResponse response) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', response.accessToken);
    await prefs.setString('user_data', jsonEncode(response.user.toJson()));
  }

  // CU-01 móvil: Registro de cliente
  // Esta pantalla registra únicamente usuarios con rol "cliente"
  Future<AuthResponse> register({
    required String nombre,
    required String correo,
    required String password,
    required String celular,
  }) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'correo': correo,
        'password': password,
        'celular': celular,
        'rol_slug': 'cliente', // Forzado según requerimiento móvil
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      await _saveSession(authResponse);
      return authResponse;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Error en el registro');
    }
  }

  // CU-02 móvil: Login
  // Esta función autentica al usuario y redirige según su rol móvil
  Future<AuthResponse> login(String correo, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'correo': correo,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final authResponse = AuthResponse.fromJson(jsonDecode(response.body));
      
      // Validar que el rol sea permitido en móvil (cliente o mecanico)
      final rol = authResponse.user.rol;
      if (rol != 'cliente' && rol != 'mecanico') {
        throw Exception('Este usuario no tiene acceso a la aplicación móvil');
      }

      await _saveSession(authResponse);
      return authResponse;
    } else {
      final error = jsonDecode(response.body);
      throw Exception(error['detail'] ?? 'Credenciales incorrectas');
    }
  }

  // CU-02 móvil: Logout
  // Esta función elimina el token y cierra la sesión del usuario
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    try {
      if (token != null) {
        await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        );
      }
    } catch (e) {
      print('Error en logout remoto: $e');
    } finally {
      // Limpiar sesión local independientemente del resultado del API
      await prefs.remove('access_token');
      await prefs.remove('user_data');
    }
  }

  Future<UserModel?> getSavedUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString('user_data');
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }
}

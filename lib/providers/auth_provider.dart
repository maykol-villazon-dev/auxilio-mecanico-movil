import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  UserModel? _user;
  bool _isLoading = false;
  String? _error;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _user = await _authService.getSavedUser();
    notifyListeners();
  }

  // CU-01 móvil: Registro de cliente
  Future<bool> register(String nombre, String correo, String password, String celular) async {
    _setLoading(true);
    _error = null;
    try {
      final response = await _authService.register(
        nombre: nombre,
        correo: correo,
        password: password,
        celular: celular,
      );
      _user = response.user;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // CU-02 móvil: Login
  Future<bool> login(String correo, String password) async {
    _setLoading(true);
    _error = null;
    try {
      final response = await _authService.login(correo, password);
      _user = response.user;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // CU-02 móvil: Logout
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}

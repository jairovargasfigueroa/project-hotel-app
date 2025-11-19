// lib/features/auth/presentation/provider/auth_provider.dart

import 'package:flutter/foundation.dart';
import '../../data/models/auth_models.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier {
  // Dependencias
  final AuthRepositoryImpl _repository;

  // Estado
  GuestUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = false;

  // Constructor con inyección de dependencias
  AuthProvider(this._repository);

  // Getters
  GuestUser? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _isAuthenticated;
  String get userDisplayName => _currentUser?.fullName ?? 'Usuario';

  /// Inicializar - Verificar si hay sesión activa
  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    try {
      _isAuthenticated = await _repository.isAuthenticated();

      if (_isAuthenticated) {
        _currentUser = await _repository.getCurrentUser();
      }
    } catch (e) {
      _isAuthenticated = false;
      _currentUser = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _repository.login(username, password);

      _currentUser = response.user;
      _isAuthenticated = true;
      _errorMessage = null;

      return true;
    } catch (e) {
      _errorMessage = _parseError(e);
      _isAuthenticated = false;
      _currentUser = null;

      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Logout
  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await _repository.logout();
    } catch (e) {
      // Ignorar errores de logout
    } finally {
      _currentUser = null;
      _isAuthenticated = false;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpiar mensajes de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Parsear errores para mostrar mensajes amigables
  String _parseError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    if (errorString.contains('network') || errorString.contains('socket')) {
      return 'Error de conexión. Verifica tu internet.';
    }

    if (errorString.contains('unauthorized') || errorString.contains('401')) {
      return 'Usuario o contraseña incorrectos.';
    }

    if (errorString.contains('timeout')) {
      return 'El servidor tardó demasiado en responder.';
    }

    return 'Error al iniciar sesión. Intenta nuevamente.';
  }

  /// Refrescar token (llamar cuando el token expire)
  Future<bool> refreshToken() async {
    try {
      final newToken = await _repository.refreshAccessToken();
      return newToken != null;
    } catch (e) {
      await logout();
      return false;
    }
  }
}

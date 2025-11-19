// lib/features/auth/data/repositories/auth_repository_impl.dart

import '../../../../core/services/notification_service.dart';
import '../../../../core/services/storage_service.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/auth_models.dart';

class AuthRepositoryImpl {
  final AuthRemoteDatasource _remoteDatasource;
  final StorageService _storage;

  AuthRepositoryImpl(this._remoteDatasource, this._storage);

  /// Login de usuario huésped
  /// Guarda los tokens en storage después de login exitoso
  Future<LoginResponse> login(String username, String password) async {
    try {
      final request = LoginRequest(username: username, password: password);

      final response = await _remoteDatasource.login(request);

      // Guardar tokens en storage
      await _storage.saveToken(response.accessToken);
      await _storage.saveRefreshToken(response.refreshToken);

      // Guardar datos del usuario (opcional)
      await _storage.saveUserData(response.user.toJson());

      // 🔥 Generar y enviar nuevo FCM token para este usuario
      await NotificationService.forceTokenRefreshAndSend();

      return response;
    } catch (e) {
      throw Exception('Error al iniciar sesión: $e');
    }
  }

  /// Logout
  /// Limpia los tokens del storage
  Future<void> logout() async {
    try {
      // Intentar logout remoto (no crítico si falla)
      await _remoteDatasource.logout();
    } catch (e) {
      // Ignorar errores del logout remoto
    }

    // 🔥 Eliminar FCM token del backend
    try {
      await NotificationService.removeTokenFromBackend();
    } catch (e) {
      // No bloquear el logout si falla
      print('⚠️ Error eliminando FCM token: $e');
    }

    // Siempre limpiar storage local
    await _storage.clearToken();
    await _storage.clearRefreshToken();
    await _storage.clearUserData();
  }

  /// Verificar si hay una sesión activa
  Future<bool> isAuthenticated() async {
    try {
      final token = await _storage.getToken();
      if (token == null || token.isEmpty) {
        return false;
      }

      // Opcional: verificar token con el backend
      // final isValid = await _remoteDatasource.verifyToken(token);
      // return isValid;

      // Por ahora solo verificamos si existe
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Obtener usuario actual del storage
  Future<GuestUser?> getCurrentUser() async {
    try {
      final userData = await _storage.getUserData();
      if (userData == null) {
        return null;
      }
      return GuestUser.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  /// Refrescar access token usando refresh token
  Future<String?> refreshAccessToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null || refreshToken.isEmpty) {
        return null;
      }

      final newAccessToken = await _remoteDatasource.refreshToken(refreshToken);

      // Guardar nuevo access token
      await _storage.saveToken(newAccessToken);

      return newAccessToken;
    } catch (e) {
      // Si falla el refresh, limpiar sesión
      await logout();
      return null;
    }
  }
}

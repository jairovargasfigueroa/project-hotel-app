// lib/features/auth/data/datasources/auth_remote_datasource.dart

import 'dart:developer' as developer;
import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/auth_models.dart';
import '../models/register_models.dart';

class AuthRemoteDatasource {
  final ApiService _apiService;

  AuthRemoteDatasource(this._apiService);

  /// Login de usuario huésped
  /// Endpoint: POST /auth/login/
  Future<LoginResponse> login(LoginRequest request) async {
    try {
      developer.log(
        '🔵 Iniciando login para usuario: ${request.username}',
        name: 'AuthDatasource',
      );

      final response = await _apiService.post('/usuarios/login/', request.toJson());

      developer.log(
        '📥 Respuesta recibida - Status: ${response.statusCode}',
        name: 'AuthDatasource',
      );

      if (response.statusCode == 200) {
        developer.log('✅ Login exitoso', name: 'AuthDatasource');
        developer.log(
          '📦 Data completa: ${response.data}',
          name: 'AuthDatasource',
        );

        final loginResponse = LoginResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        developer.log(
          '✅ LoginResponse parseado correctamente - Usuario: ${loginResponse.user.username}',
          name: 'AuthDatasource',
        );

        return loginResponse;
      } else {
        developer.log(
          '❌ Error en login: ${response.statusCode}',
          name: 'AuthDatasource',
          error: response.data,
        );
        throw Exception(
          'Error en login: ${response.data?['message'] ?? 'Error desconocido'}',
        );
      }
    } catch (e) {
      developer.log('❌ Excepción en login', name: 'AuthDatasource', error: e);
      rethrow;
    }
  }

  /// Logout (opcional, si el backend tiene endpoint)
  /// Endpoint: POST /auth/logout/
  Future<void> logout() async {
    try {
      developer.log('🔵 Iniciando logout', name: 'AuthDatasource');

      final response = await _apiService.post('/usuarios/logout/', {});

      developer.log(
        '✅ Logout exitoso - Status: ${response.statusCode}',
        name: 'AuthDatasource',
      );
    } catch (e) {
      developer.log('❌ Error en logout', name: 'AuthDatasource', error: e);
      // No lanzamos error porque el logout local debe funcionar aunque falle el remoto
    }
  }

  /// Registro de usuario
  /// Endpoint: POST /usuarios/register/
  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      developer.log(
        '🔵 Iniciando registro para usuario: ${request.username}',
        name: 'AuthDatasource',
      );

      // Si hay foto, enviar como FormData
      dynamic requestData;
      if (request.photoFile != null) {
        final formData = FormData.fromMap({
          'username': request.username,
          'password': request.password,
          'email': request.email,
          if (request.firstName != null && request.firstName!.isNotEmpty)
            'first_name': request.firstName,
          if (request.lastName != null && request.lastName!.isNotEmpty)
            'last_name': request.lastName,
          'photo': await MultipartFile.fromFile(
            request.photoFile!.path,
            filename: 'profile_photo.jpg',
          ),
        });
        requestData = formData;
        
        developer.log(
          '📸 Enviando registro con foto de perfil',
          name: 'AuthDatasource',
        );
      } else {
        requestData = request.toJson();
      }

      final response = await _apiService.post('/usuarios/register/', requestData);

      developer.log(
        '📥 Respuesta recibida - Status: ${response.statusCode}',
        name: 'AuthDatasource',
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        developer.log('✅ Registro exitoso', name: 'AuthDatasource');
        developer.log(
          '📦 Data completa: ${response.data}',
          name: 'AuthDatasource',
        );

        final registerResponse = RegisterResponse.fromJson(
          response.data as Map<String, dynamic>,
        );

        developer.log(
          '✅ RegisterResponse parseado correctamente - Usuario: ${registerResponse.user.username}',
          name: 'AuthDatasource',
        );

        return registerResponse;
      } else {
        developer.log(
          '❌ Error en registro: ${response.statusCode}',
          name: 'AuthDatasource',
          error: response.data,
        );
        throw Exception(
          'Error en registro: ${response.data?['message'] ?? 'Error desconocido'}',
        );
      }
    } catch (e) {
      developer.log('❌ Excepción en registro', name: 'AuthDatasource', error: e);
      rethrow;
    }
  }

  /// Verificar token (opcional)
  /// Endpoint: POST /auth/verify-token/
  Future<bool> verifyToken(String token) async {
    try {
      developer.log('🔵 Verificando token', name: 'AuthDatasource');

      final response = await _apiService.post('/usuarios/verify-token/', {
        'token': token,
      });

      final isValid = response.statusCode == 200;

      developer.log(
        isValid ? '✅ Token válido' : '❌ Token inválido',
        name: 'AuthDatasource',
      );

      return isValid;
    } catch (e) {
      developer.log(
        '❌ Error verificando token',
        name: 'AuthDatasource',
        error: e,
      );
      return false;
    }
  }

  /// Refresh token (opcional)
  /// Endpoint: POST /auth/refresh/
  Future<String> refreshToken(String refreshToken) async {
    try {
      developer.log('🔵 Refrescando token', name: 'AuthDatasource');

      final response = await _apiService.post('/usuarios/refresh_token/', {
        'refresh': refreshToken,
      });

      if (response.statusCode == 200) {
        final newAccessToken = response.data['access'] as String;

        developer.log(
          '✅ Token refrescado exitosamente',
          name: 'AuthDatasource',
        );

        return newAccessToken;
      } else {
        throw Exception('Error al refrescar token');
      }
    } catch (e) {
      developer.log(
        '❌ Error refrescando token',
        name: 'AuthDatasource',
        error: e,
      );
      rethrow;
    }
  }
}

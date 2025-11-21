import 'dart:developer' as developer;
import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/services/api_service.dart';
import '../models/perfil_model.dart';


class PerfilRemoteDatasource {
  final ApiService _apiService;

  PerfilRemoteDatasource(this._apiService);

  Future<List<PerfilModel>> getPerfil() async {

    try {
      developer.log(
        'Iniciando petición GET /usuarios/me/',
        name: 'PerfilDataSource',
      );

      final response = await _apiService.get('api/usuarios/me/');

      developer.log(
        '📥 Respuesta recibida - Status: ${response.statusCode}',
        name: 'PerfilDataSource',
      );

      if (response.statusCode == 200) {
        developer.log(
          '📦 Data del perfil: ${response.data}',
          name: 'PerfilDataSource',
        );

        final perfil = PerfilModel.fromJson(response.data);

        developer.log(
          '✅ Perfil parseado: ${perfil.username}',
          name: 'PerfilDataSource',
        );

        return [perfil];
      } else {
        developer.log(
          '❌ Error en respuesta: ${response.statusCode}',
          name: 'PerfilDataSource',
          error: response.data,
        );
        throw Exception('Error al obtener perfil: ${response.statusCode}');
      }
    } catch (e) {
      developer.log(
        '❌ Error en comunicación con servidor',
        name: 'PerfilDataSource',
        error: e,
      );
      throw Exception('Error en la comunicación con el servidor: $e');
    }

  }

  /// Actualizar perfil de usuario
  /// Endpoint: PATCH /usuarios/updateprofile/
  Future<PerfilModel> updatePerfil({
    String? firstName,
    String? lastName,
    String? email,
    File? photoFile,
  }) async {
    try {
      developer.log(
        'Iniciando actualización de perfil',
        name: 'PerfilDataSource',
      );

      dynamic requestData;

      // Si hay foto, enviar como FormData
      if (photoFile != null) {
        final formData = FormData.fromMap({
          if (firstName != null) 'first_name': firstName,
          if (lastName != null) 'last_name': lastName,
          if (email != null) 'email': email,
          'photo': await MultipartFile.fromFile(
            photoFile.path,
            filename: 'profile_photo.jpg',
          ),
        });
        requestData = formData;
        developer.log('📸 Actualizando con nueva foto', name: 'PerfilDataSource');
      } else {
        // Sin foto, enviar JSON
        final Map<String, dynamic> data = {};
        if (firstName != null) data['first_name'] = firstName;
        if (lastName != null) data['last_name'] = lastName;
        if (email != null) data['email'] = email;
        requestData = data;
      }

      final response = await _apiService.patch('api/usuarios/updateprofile/', requestData);

      developer.log(
        '📥 Respuesta recibida - Status: ${response.statusCode}',
        name: 'PerfilDataSource',
      );

      if (response.statusCode == 200) {
        developer.log(
          '✅ Perfil actualizado correctamente',
          name: 'PerfilDataSource',
        );

        final perfil = PerfilModel.fromJson(response.data);
        return perfil;
      } else {
        developer.log(
          '❌ Error en actualización: ${response.statusCode}',
          name: 'PerfilDataSource',
          error: response.data,
        );
        throw Exception('Error al actualizar perfil: ${response.statusCode}');
      }
    } catch (e) {
      developer.log(
        '❌ Error en actualización de perfil',
        name: 'PerfilDataSource',
        error: e,
      );
      rethrow;
    }
  }

}
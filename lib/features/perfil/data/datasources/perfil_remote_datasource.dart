import 'dart:developer' as developer;
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

      final response = await _apiService.get('/usuarios/me/');

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



}
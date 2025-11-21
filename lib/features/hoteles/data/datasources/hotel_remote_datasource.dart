// lib/features/hoteles/data/datasources/hotel_remote_datasource.dart

import 'dart:developer' as developer;
import '../../../../core/services/api_service.dart';
import '../models/hotel_model.dart';

class HotelRemoteDatasource {
  final ApiService _apiService;

  HotelRemoteDatasource(this._apiService);

  /// Obtiene la lista de todos los hoteles desde el backend
  Future<List<HotelModel>> getHoteles() async {
    try {
      developer.log(
        '🔵 Iniciando petición GET /hoteles/',
        name: 'HotelDatasource',
      );

      final response = await _apiService.get('api/hoteles/hoteles/');

      developer.log(
        '📥 Respuesta recibida - Status: ${response.statusCode}',
        name: 'HotelDatasource',
      );

      // Si la respuesta es exitosa, parsear los datos
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List<dynamic>;

        developer.log(
          '✅ Hoteles recibidos: ${data.length} items',
          name: 'HotelDatasource',
        );
        developer.log('📦 Data completa: $data', name: 'HotelDatasource');

        final hoteles = data.map((json) => HotelModel.fromJson(json)).toList();

        developer.log(
          '✅ Hoteles parseados correctamente',
          name: 'HotelDatasource',
        );

        return hoteles;
      } else {
        developer.log(
          '❌ Error en respuesta: ${response.statusCode}',
          name: 'HotelDatasource',
          error: response.data,
        );
        throw Exception('Error al obtener hoteles: ${response.statusCode}');
      }
    } catch (e) {
      developer.log(
        '❌ Error en comunicación con servidor',
        name: 'HotelDatasource',
        error: e,
      );
      throw Exception('Error en la comunicación con el servidor: $e');
    }
  }

  /// Obtiene un hotel específico por ID
  Future<HotelModel> getHotelById(int id) async {
    try {
      developer.log(
        '🔵 Iniciando petición GET /hoteles/$id',
        name: 'HotelDatasource',
      );

      final response = await _apiService.get('/hoteles/$id');

      developer.log(
        '📥 Respuesta recibida - Status: ${response.statusCode}',
        name: 'HotelDatasource',
      );

      if (response.statusCode == 200) {
        developer.log(
          '📦 Data del hotel: ${response.data}',
          name: 'HotelDatasource',
        );

        final hotel = HotelModel.fromJson(response.data);

        developer.log(
          '✅ Hotel parseado: ${hotel.nombre}',
          name: 'HotelDatasource',
        );

        return hotel;
      } else {
        developer.log(
          '❌ Error en respuesta: ${response.statusCode}',
          name: 'HotelDatasource',
          error: response.data,
        );
        throw Exception('Error al obtener hotel: ${response.statusCode}');
      }
    } catch (e) {
      developer.log(
        '❌ Error en comunicación con servidor',
        name: 'HotelDatasource',
        error: e,
      );
      throw Exception('Error en la comunicación con el servidor: $e');
    }
  }
}

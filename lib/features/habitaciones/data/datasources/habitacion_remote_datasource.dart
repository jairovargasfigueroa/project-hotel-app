// lib/features/habitaciones/data/datasources/habitacion_remote_datasource.dart

import 'dart:developer' as developer;
import '../../../../core/services/api_service.dart';
import '../models/habitacion_model.dart';

class HabitacionRemoteDatasource {
  final ApiService _apiService;

  HabitacionRemoteDatasource(this._apiService);

  /// Obtener habitaciones de un hotel específico
  Future<List<HabitacionModel>> getHabitacionesByHotel(int hotelId) async {
    try {
      developer.log(
        'Iniciando petición para habitaciones del hotel: $hotelId',
        name: 'HabitacionRemoteDatasource',
      );

      final response = await _apiService.dio.get(
        'api/habitaciones/por-hotel/',
        queryParameters: {'hotel_id': hotelId},
      );

      developer.log(
        'Respuesta recibida - Status: ${response.statusCode}',
        name: 'HabitacionRemoteDatasource',
      );
      developer.log(
        'Data: ${response.data}',
        name: 'HabitacionRemoteDatasource',
      );

      if (response.data is List) {
        final habitaciones =
            (response.data as List)
                .map((json) => HabitacionModel.fromJson(json))
                .toList();

        developer.log(
          'Total habitaciones parseadas: ${habitaciones.length}',
          name: 'HabitacionRemoteDatasource',
        );

        return habitaciones;
      }

      throw Exception('Formato de respuesta inválido');
    } catch (e) {
      developer.log(
        'Error al obtener habitaciones: $e',
        name: 'HabitacionRemoteDatasource',
        error: e,
      );
      rethrow;
    }
  }

  /// Obtener una habitación por ID
  Future<HabitacionModel> getHabitacionById(int id) async {
    try {
      developer.log(
        'Obteniendo habitación con ID: $id',
        name: 'HabitacionRemoteDatasource',
      );

      final response = await _apiService.dio.get('api/habitaciones/$id/');

      developer.log(
        'Habitación obtenida - Status: ${response.statusCode}',
        name: 'HabitacionRemoteDatasource',
      );

      return HabitacionModel.fromJson(response.data);
    } catch (e) {
      developer.log(
        'Error al obtener habitación por ID: $e',
        name: 'HabitacionRemoteDatasource',
        error: e,
      );
      rethrow;
    }
  }
}

// lib/features/reservas/data/datasources/reserva_remote_datasource.dart

import 'dart:developer' as developer;
import '../../../../core/services/api_service.dart';
import '../models/reserva_model.dart';

class ReservaRemoteDatasource {
  final ApiService _apiService;

  ReservaRemoteDatasource(this._apiService);

  /// Crear una nueva reserva
  Future<void> createReserva(ReservaModel reserva) async {
    try {
      developer.log(
        'Creando reserva: ${reserva.toJson()}',
        name: 'ReservaRemoteDatasource',
      );

      final response = await _apiService.dio.post(
        '/reservas/',
        data: reserva.toJson(),
      );

      developer.log(
        'Reserva creada - Status: ${response.statusCode}',
        name: 'ReservaRemoteDatasource',
      );

      // Verificar que el status sea exitoso
      if (response.statusCode == 200 || response.statusCode == 201) {
        developer.log(
          '✅ Reserva creada exitosamente',
          name: 'ReservaRemoteDatasource',
        );
        return;
      }

      throw Exception('Error inesperado: ${response.statusCode}');
    } catch (e) {
      developer.log(
        'Error al crear reserva: $e',
        name: 'ReservaRemoteDatasource',
        error: e,
      );
      rethrow;
    }
  }

  /// Obtener reservas por huésped
  Future<List<ReservaModel>> getReservasByHuesped(int huespedId) async {
    try {
      developer.log(
        'Obteniendo reservas del huésped: $huespedId',
        name: 'ReservaRemoteDatasource',
      );

      final response = await _apiService.dio.get(
        '/reservas/',
        queryParameters: {'huesped': huespedId},
      );

      developer.log(
        'Respuesta recibida - Status: ${response.statusCode}',
        name: 'ReservaRemoteDatasource',
      );

      if (response.data is List) {
        final reservas =
            (response.data as List)
                .map((json) => ReservaModel.fromJson(json))
                .toList();

        developer.log(
          'Total reservas obtenidas: ${reservas.length}',
          name: 'ReservaRemoteDatasource',
        );

        return reservas;
      }

      throw Exception('Formato de respuesta inválido');
    } catch (e) {
      developer.log(
        'Error al obtener reservas: $e',
        name: 'ReservaRemoteDatasource',
        error: e,
      );
      rethrow;
    }
  }
}

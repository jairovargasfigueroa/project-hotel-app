// lib/features/habitaciones/data/repositories/habitacion_repository_impl.dart

import '../datasources/habitacion_remote_datasource.dart';
import '../models/habitacion_model.dart';

class HabitacionRepositoryImpl {
  final HabitacionRemoteDatasource _remoteDatasource;

  HabitacionRepositoryImpl(this._remoteDatasource);

  /// Obtener todas las habitaciones de un hotel
  Future<List<HabitacionModel>> getHabitacionesByHotel(int hotelId) async {
    try {
      return await _remoteDatasource.getHabitacionesByHotel(hotelId);
    } catch (e) {
      throw Exception('Error al obtener habitaciones del hotel: $e');
    }
  }

  /// Obtener habitación por ID
  Future<HabitacionModel> getHabitacionById(int id) async {
    try {
      return await _remoteDatasource.getHabitacionById(id);
    } catch (e) {
      throw Exception('Error al obtener habitación: $e');
    }
  }

  /// Filtrar solo habitaciones disponibles
  Future<List<HabitacionModel>> getHabitacionesDisponibles(int hotelId) async {
    try {
      final habitaciones = await _remoteDatasource.getHabitacionesByHotel(
        hotelId,
      );
      return habitaciones
          .where((hab) => hab.estado.toLowerCase() == 'disponible')
          .toList();
    } catch (e) {
      throw Exception('Error al obtener habitaciones disponibles: $e');
    }
  }
}

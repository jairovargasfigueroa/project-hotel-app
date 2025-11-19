// lib/features/reservas/data/repositories/reserva_repository_impl.dart

import '../datasources/reserva_remote_datasource.dart';
import '../models/reserva_model.dart';
import '../models/mis_reservas_response_model.dart';

class ReservaRepositoryImpl {
  final ReservaRemoteDatasource _remoteDatasource;

  ReservaRepositoryImpl(this._remoteDatasource);

  /// Obtener mis reservas (del usuario autenticado)
  Future<MisReservasResponseModel> getMisReservas() async {
    try {
      return await _remoteDatasource.getMisReservas();
    } catch (e) {
      throw Exception('Error al obtener mis reservas: $e');
    }
  }

  /// Crear una nueva reserva
  Future<void> createReserva(ReservaModel reserva) async {
    try {
      await _remoteDatasource.createReserva(reserva);
    } catch (e) {
      throw Exception('Error al crear reserva: $e');
    }
  }

  /// Obtener reservas por huésped
  Future<List<ReservaModel>> getReservasByHuesped(int huespedId) async {
    try {
      return await _remoteDatasource.getReservasByHuesped(huespedId);
    } catch (e) {
      throw Exception('Error al obtener reservas: $e');
    }
  }
}


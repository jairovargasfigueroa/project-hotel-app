// lib/features/hoteles/data/repositories/hotel_repository_impl.dart

import '../datasources/hotel_remote_datasource.dart';
import '../models/hotel_model.dart';

class HotelRepositoryImpl {
  final HotelRemoteDatasource _remoteDatasource;

  HotelRepositoryImpl(this._remoteDatasource);

  /// Obtiene la lista de todos los hoteles
  /// Maneja errores y transforma excepciones si es necesario
  Future<List<HotelModel>> getHoteles() async {
    try {
      return await _remoteDatasource.getHoteles();
    } catch (e) {
      // Aquí podrías transformar errores específicos
      // Por ejemplo: NetworkException, ServerException, etc.
      throw Exception('Error al obtener la lista de hoteles: $e');
    }
  }

  /// Obtiene un hotel específico por ID
  Future<HotelModel> getHotelById(int id) async {
    try {
      return await _remoteDatasource.getHotelById(id);
    } catch (e) {
      throw Exception('Error al obtener el hotel con ID $id: $e');
    }
  }

  /// Filtra hoteles activos (estado = "Activo")
  Future<List<HotelModel>> getHotelesActivos() async {
    try {
      final hoteles = await _remoteDatasource.getHoteles();
      return hoteles
          .where((hotel) => hotel.estado.toLowerCase() == 'activo')
          .toList();
    } catch (e) {
      throw Exception('Error al obtener hoteles activos: $e');
    }
  }
}

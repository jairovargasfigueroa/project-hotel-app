// lib/features/perfil/data/repositories/perfil_repository_impl.dart

import '../datasources/perfil_remote_datasource.dart';
import '../models/perfil_model.dart';

class PerfilRepositoryImpl {
  final PerfilRemoteDatasource _remoteDatasource;

  PerfilRepositoryImpl(this._remoteDatasource);

  /// Obtiene los datos del perfil del usuario autenticado
  /// Maneja errores y transforma excepciones si es necesario
  Future<PerfilModel> getPerfil() async {
    try {
      final perfils = await _remoteDatasource.getPerfil();
      if (perfils.isEmpty) {
        throw Exception('No se encontraron datos del perfil');
      }
      return perfils.first;
    } catch (e) {
      throw Exception('Error al obtener el perfil del usuario: $e');
    }
  }
}

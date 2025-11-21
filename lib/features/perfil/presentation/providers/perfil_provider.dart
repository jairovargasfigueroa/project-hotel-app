// lib/features/perfil/presentation/providers/perfil_provider.dart

import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../../data/datasources/perfil_remote_datasource.dart';
import '../../data/models/perfil_model.dart';
import '../../data/repositories/hotel_repository_impl.dart';

class PerfilProvider extends ChangeNotifier {
  // Dependencias
  final PerfilRepositoryImpl _repository;

  // Estado
  PerfilModel? _perfil;
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor con inyección de dependencias
  PerfilProvider(this._repository);

  // Getters
  PerfilModel? get perfil => _perfil;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasPerfil => _perfil != null;

  /// Cargar datos del perfil desde el backend
  Future<void> loadPerfil() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _perfil = await _repository.getPerfil();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar perfil: $e';
      _perfil = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Actualizar perfil del usuario
  Future<bool> updatePerfil({
    String? firstName,
    String? lastName,
    String? email,
    File? photoFile,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _perfil = await _repository.updatePerfil(
        firstName: firstName,
        lastName: lastName,
        email: email,
        photoFile: photoFile,
      );
      _errorMessage = null;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Error al actualizar perfil: $e';
      notifyListeners();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recargar datos del perfil
  Future<void> reload() async {
    await loadPerfil();
  }

  /// Limpiar datos del perfil
  void clearPerfil() {
    _perfil = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

/// Factory para crear la instancia del provider con sus dependencias
PerfilProvider createPerfilProvider() {
  final apiService = ApiService();
  final datasource = PerfilRemoteDatasource(apiService);
  final repository = PerfilRepositoryImpl(datasource);
  return PerfilProvider(repository);
}

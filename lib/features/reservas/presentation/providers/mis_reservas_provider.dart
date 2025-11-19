// lib/features/reservas/presentation/providers/mis_reservas_provider.dart

import 'package:flutter/foundation.dart';
import '../../data/models/mis_reservas_response_model.dart';
import '../../data/models/mi_reserva_model.dart';
import '../../data/repositories/reserva_repository_impl.dart';
import '../../../../core/services/api_service.dart';
import '../../data/datasources/reserva_remote_datasource.dart';

class MisReservasProvider extends ChangeNotifier {
  final ReservaRepositoryImpl _repository;

  // Estado
  MisReservasResponseModel? _misReservasResponse;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isAuthenticated = true; // Asumimos que está autenticado si tiene token

  // Constructor con inyección de dependencias
  MisReservasProvider(this._repository);

  // Getters
  MisReservasResponseModel? get misReservasResponse => _misReservasResponse;
  List<MiReservaModel> get reservas => _misReservasResponse?.reservas ?? [];
  int get totalReservas => _misReservasResponse?.totalReservas ?? 0;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasReservas => reservas.isNotEmpty;
  bool get isAuthenticated => _isAuthenticated;
  UsuarioInfoModel? get usuario => _misReservasResponse?.usuario;

  /// Cargar mis reservas desde el backend
  Future<void> loadMisReservas() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _misReservasResponse = await _repository.getMisReservas();
      _errorMessage = null;
      _isAuthenticated = true;
    } catch (e) {
      // Si es error 401, el usuario no está autenticado
      if (e.toString().contains('401')) {
        _isAuthenticated = false;
        _errorMessage = 'Debes iniciar sesión para ver tus reservas';
      } else {
        _errorMessage = 'Error al cargar reservas: $e';
      }
      _misReservasResponse = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Recargar datos
  Future<void> reload() async {
    await loadMisReservas();
  }

  /// Limpiar datos
  void clearReservas() {
    _misReservasResponse = null;
    _errorMessage = null;
    notifyListeners();
  }

  /// Filtrar reservas por estado
  List<MiReservaModel> getReservasByEstado(String estado) {
    return reservas
        .where((reserva) => reserva.estado.toLowerCase() == estado.toLowerCase())
        .toList();
  }

  /// Obtener reservas activas (confirmadas, pendientes)
  List<MiReservaModel> get reservasActivas {
    return reservas
        .where((reserva) =>
            reserva.estado.toLowerCase() == 'confirmada' ||
            reserva.estado.toLowerCase() == 'pendiente')
        .toList();
  }

  /// Obtener reservas pasadas
  List<MiReservaModel> get reservasPasadas {
    final now = DateTime.now();
    return reservas.where((reserva) {
      final fechaSalida = DateTime.parse(reserva.fechaSalida);
      return fechaSalida.isBefore(now);
    }).toList();
  }

  /// Obtener reservas futuras
  List<MiReservaModel> get reservasFuturas {
    final now = DateTime.now();
    return reservas.where((reserva) {
      final fechaEntrada = DateTime.parse(reserva.fechaEntrada);
      return fechaEntrada.isAfter(now);
    }).toList();
  }
}

/// Factory para crear la instancia del provider con sus dependencias
MisReservasProvider createMisReservasProvider() {
  final apiService = ApiService();
  final datasource = ReservaRemoteDatasource(apiService);
  final repository = ReservaRepositoryImpl(datasource);
  return MisReservasProvider(repository);
}

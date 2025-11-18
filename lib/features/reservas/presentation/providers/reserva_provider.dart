// lib/features/reservas/presentation/providers/reserva_provider.dart

import 'package:flutter/foundation.dart';
import '../../data/models/reserva_model.dart';
import '../../data/repositories/reserva_repository_impl.dart';

class ReservaProvider extends ChangeNotifier {
  final ReservaRepositoryImpl _repository;

  ReservaProvider(this._repository);

  // Estado
  bool _isLoading = false;
  String? _errorMessage;
  List<ReservaModel> _misReservas = [];

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ReservaModel> get misReservas => _misReservas;

  /// Crear nueva reserva
  Future<bool> createReserva({
    required int habitacionId,
    required int hotelId,
    required DateTime fechaEntrada,
    required DateTime fechaSalida,
    required double total,
    required int huespedId,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final reserva = ReservaModel(
        habitacion: habitacionId,
        hotel: hotelId,
        fechaEntrada: fechaEntrada.toIso8601String().split('T')[0],
        fechaSalida: fechaSalida.toIso8601String().split('T')[0],
        total: total,
        huesped: huespedId,
      );

      await _repository.createReserva(reserva);
      _errorMessage = null;
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar reservas del huésped
  Future<void> loadReservasByHuesped(int huespedId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _misReservas = await _repository.getReservasByHuesped(huespedId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _misReservas = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Limpiar error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}

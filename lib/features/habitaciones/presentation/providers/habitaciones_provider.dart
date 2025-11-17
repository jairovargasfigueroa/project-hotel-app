// lib/features/habitaciones/presentation/providers/habitaciones_provider.dart

import 'package:flutter/foundation.dart';
import '../../data/models/habitacion_model.dart';
import '../../data/repositories/habitacion_repository_impl.dart';

class HabitacionesProvider extends ChangeNotifier {
  final HabitacionRepositoryImpl _repository;

  HabitacionesProvider(this._repository);

  // Estado
  List<HabitacionModel> _habitaciones = [];
  bool _isLoading = false;
  String? _errorMessage;
  HabitacionModel? _selectedHabitacion;
  int? _currentHotelId;

  // Getters
  List<HabitacionModel> get habitaciones => _habitaciones;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  HabitacionModel? get selectedHabitacion => _selectedHabitacion;
  bool get hasSelectedHabitacion => _selectedHabitacion != null;

  // Obtener solo habitaciones disponibles
  List<HabitacionModel> get habitacionesDisponibles =>
      _habitaciones
          .where((hab) => hab.estado.toLowerCase() == 'disponible')
          .toList();

  /// Cargar habitaciones de un hotel
  Future<void> loadHabitaciones(int hotelId) async {
    // Si ya se cargaron las habitaciones de este hotel, no recargar
    if (_currentHotelId == hotelId && _habitaciones.isNotEmpty && !_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _currentHotelId = hotelId;
    notifyListeners();

    try {
      _habitaciones = await _repository.getHabitacionesByHotel();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _habitaciones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar solo habitaciones disponibles
  Future<void> loadHabitacionesDisponibles(int hotelId) async {
    _isLoading = true;
    _errorMessage = null;
    _currentHotelId = hotelId;
    notifyListeners();

    try {
      _habitaciones = await _repository.getHabitacionesDisponibles(hotelId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _habitaciones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Seleccionar una habitación
  void selectHabitacion(HabitacionModel? habitacion) {
    _selectedHabitacion = habitacion;
    notifyListeners();
  }

  /// Recargar habitaciones
  Future<void> reload() async {
    if (_currentHotelId != null) {
      _habitaciones = [];
      await loadHabitaciones(_currentHotelId!);
    }
  }

  /// Limpiar estado cuando cambia de hotel
  void clearHabitaciones() {
    _habitaciones = [];
    _selectedHabitacion = null;
    _errorMessage = null;
    _currentHotelId = null;
    notifyListeners();
  }
}

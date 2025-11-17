// lib/features/hoteles/presentation/providers/hotels_provider.dart

import 'package:flutter/foundation.dart';
import '../../../../core/services/api_service.dart';
import '../../data/datasources/hotel_remote_datasource.dart';
import '../../data/models/hotel_model.dart';
import '../../data/repositories/hotel_repository_impl.dart';

class HotelsProvider extends ChangeNotifier {
  // Dependencias
  final HotelRepositoryImpl _repository;

  // Estado
  List<HotelModel> _hoteles = [];
  HotelModel? _selectedHotel;
  bool _isLoading = false;
  String? _errorMessage;

  // Constructor con inyección de dependencias
  HotelsProvider(this._repository);

  // Getters
  List<HotelModel> get hoteles => _hoteles;
  HotelModel? get selectedHotel => _selectedHotel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasSelectedHotel => _selectedHotel != null;

  // Obtener solo hoteles activos
  List<HotelModel> get hotelesActivos =>
      _hoteles
          .where((hotel) => hotel.estado.toLowerCase() == 'activo')
          .toList();

  /// Cargar lista de hoteles desde el backend
  Future<void> loadHoteles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _hoteles = await _repository.getHoteles();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar hoteles: $e';
      _hoteles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Cargar solo hoteles activos
  Future<void> loadHotelesActivos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _hoteles = await _repository.getHotelesActivos();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Error al cargar hoteles: $e';
      _hoteles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Seleccionar un hotel
  void selectHotel(HotelModel? hotel) {
    _selectedHotel = hotel;
    notifyListeners();
  }

  /// Limpiar selección
  void clearSelection() {
    _selectedHotel = null;
    notifyListeners();
  }

  /// Recargar datos
  Future<void> reload() async {
    await loadHotelesActivos();
  }
}

/// Factory para crear la instancia del provider con sus dependencias
HotelsProvider createHotelsProvider() {
  final apiService = ApiService();
  final datasource = HotelRemoteDatasource(apiService);
  final repository = HotelRepositoryImpl(datasource);
  return HotelsProvider(repository);
}

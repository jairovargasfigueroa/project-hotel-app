// lib/features/habitaciones/presentation/screens/habitaciones_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../hoteles/presentation/providers/hotels_provider.dart';
import '../widgets/habitaciones_list_widget.dart';
import '../../../hoteles/presentation/widgets/hotel_selector_dropdown.dart';

class HabitacionesScreen extends StatefulWidget {
  const HabitacionesScreen({super.key});

  @override
  State<HabitacionesScreen> createState() => _HabitacionesScreenState();
}

class _HabitacionesScreenState extends State<HabitacionesScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar hoteles si no están cargados
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final hotelsProvider = context.read<HotelsProvider>();
      if (hotelsProvider.hoteles.isEmpty) {
        hotelsProvider.loadHotelesActivos();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<HotelsProvider>(
        builder: (context, hotelsProvider, child) {
          // Loading state
          if (hotelsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Error state
          if (hotelsProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar hoteles',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Text(
                      hotelsProvider.errorMessage!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => hotelsProvider.reload(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          // Empty state
          if (hotelsProvider.hotelesActivos.isEmpty) {
            return const Center(
              child: Text(
                'No hay hoteles disponibles',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          // Success state - Mostrar selector de hotel y habitaciones
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Selector de hotel
                const Text(
                  'Selecciona un hotel para ver sus habitaciones',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                const HotelSelectorDropdown(),
                const SizedBox(height: 24),

                // Lista de habitaciones
                Expanded(
                  child:
                      hotelsProvider.hasSelectedHotel
                          ? HabitacionesListWidget(
                            hotelId: hotelsProvider.selectedHotel!.id!,
                          )
                          : const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.bed_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Selecciona un hotel para ver las habitaciones',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

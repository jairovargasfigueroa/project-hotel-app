// lib/features/habitaciones/presentation/widgets/habitaciones_list_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/habitaciones_provider.dart';
import '../../../reservas/presentation/screens/crear_reserva_screen.dart';

class HabitacionesListWidget extends StatefulWidget {
  final int hotelId;

  const HabitacionesListWidget({super.key, required this.hotelId});

  @override
  State<HabitacionesListWidget> createState() => _HabitacionesListWidgetState();
}

class _HabitacionesListWidgetState extends State<HabitacionesListWidget> {
  @override
  void initState() {
    super.initState();
    // Cargar habitaciones al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HabitacionesProvider>().loadHabitaciones(widget.hotelId);
    });
  }

  @override
  void didUpdateWidget(HabitacionesListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambia el hotel, recargar habitaciones
    if (oldWidget.hotelId != widget.hotelId) {
      context.read<HabitacionesProvider>().clearHabitaciones();
      context.read<HabitacionesProvider>().loadHabitaciones(widget.hotelId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HabitacionesProvider>(
      builder: (context, provider, child) {
        // Loading state
        if (provider.isLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Error state
        if (provider.errorMessage != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar habitaciones',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[700],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    provider.errorMessage!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => provider.reload(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        }

        // Empty state
        if (provider.habitaciones.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.hotel_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No hay habitaciones disponibles',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
          );
        }

        // Success state - Lista de habitaciones
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Habitaciones (${provider.habitaciones.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () => provider.reload(),
                    icon: const Icon(Icons.refresh),
                    tooltip: 'Recargar',
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: provider.habitaciones.length,
                itemBuilder: (context, index) {
                  final habitacion = provider.habitaciones[index];
                  final isDisponible =
                      habitacion.estado.toLowerCase() == 'disponible';

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor:
                            isDisponible
                                ? Colors.green.shade100
                                : Colors.grey.shade300,
                        child: Icon(
                          Icons.hotel,
                          color: isDisponible ? Colors.green : Colors.grey,
                        ),
                      ),
                      title: Text(
                        'Habitación ${habitacion.numero}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text(
                            '${habitacion.tipo.toUpperCase()} • ${habitacion.tamanio}',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.person, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${habitacion.capacidad} personas',
                                style: const TextStyle(fontSize: 13),
                              ),
                              const SizedBox(width: 16),
                              Icon(
                                Icons.circle,
                                size: 8,
                                color: isDisponible ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                habitacion.estado.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 13,
                                  color:
                                      isDisponible ? Colors.green : Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '\$${habitacion.precioNoche}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const Text(
                            'por noche',
                            style: TextStyle(fontSize: 11, color: Colors.grey),
                          ),
                        ],
                      ),
                      onTap: () {
                        provider.selectHabitacion(habitacion);
                        // Navegar a la pantalla de crear reserva
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    CrearReservaScreen(habitacion: habitacion),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

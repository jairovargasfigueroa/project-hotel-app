// lib/features/reservas/presentation/screens/crear_reserva_screen.dart

import 'package:flutter/material.dart';
import '../../../habitaciones/data/models/habitacion_model.dart';
import '../widgets/habitacion_detail_card.dart';
import '../widgets/date_selector_widget.dart';
import '../widgets/reserva_summary_card.dart';
import '../widgets/confirm_reserva_button.dart';

class CrearReservaScreen extends StatefulWidget {
  final HabitacionModel habitacion;

  const CrearReservaScreen({super.key, required this.habitacion});

  @override
  State<CrearReservaScreen> createState() => _CrearReservaScreenState();
}

class _CrearReservaScreenState extends State<CrearReservaScreen> {
  DateTime? _fechaEntrada;
  DateTime? _fechaSalida;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Reserva'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card con detalles de la habitación
            HabitacionDetailCard(habitacion: widget.habitacion),

            const SizedBox(height: 24),

            // Título de sección
            const Text(
              'Fechas de Reserva',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            // Selector de fecha de entrada
            DateSelectorWidget(
              label: 'Fecha de Entrada',
              fecha: _fechaEntrada,
              onDateSelected: (fecha) {
                setState(() {
                  _fechaEntrada = fecha;
                  // Si la fecha de salida es anterior a la nueva entrada, resetear
                  if (_fechaSalida != null && _fechaSalida!.isBefore(fecha)) {
                    _fechaSalida = null;
                  }
                });
              },
            ),

            const SizedBox(height: 16),

            // Selector de fecha de salida
            DateSelectorWidget(
              label: 'Fecha de Salida',
              fecha: _fechaSalida,
              enabled: _fechaEntrada != null,
              minDate: _fechaEntrada?.add(const Duration(days: 1)),
              onDateSelected: (fecha) {
                setState(() {
                  _fechaSalida = fecha;
                });
              },
            ),

            const SizedBox(height: 24),

            // Resumen de costos
            ReservaSummaryCard(
              habitacion: widget.habitacion,
              fechaEntrada: _fechaEntrada,
              fechaSalida: _fechaSalida,
            ),

            const SizedBox(height: 32),

            // Botón de confirmar
            ConfirmReservaButton(
              habitacion: widget.habitacion,
              fechaEntrada: _fechaEntrada,
              fechaSalida: _fechaSalida,
            ),
          ],
        ),
      ),
    );
  }
}

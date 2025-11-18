// lib/features/reservas/presentation/widgets/reserva_summary_card.dart

import 'package:flutter/material.dart';
import '../../../habitaciones/data/models/habitacion_model.dart';

class ReservaSummaryCard extends StatelessWidget {
  final HabitacionModel habitacion;
  final DateTime? fechaEntrada;
  final DateTime? fechaSalida;

  const ReservaSummaryCard({
    super.key,
    required this.habitacion,
    required this.fechaEntrada,
    required this.fechaSalida,
  });

  int get _numeroDias {
    if (fechaEntrada == null || fechaSalida == null) return 0;
    return fechaSalida!.difference(fechaEntrada!).inDays;
  }

  double get _precioNoche {
    return double.tryParse(habitacion.precioNoche) ?? 0.0;
  }

  double get _totalCalculado {
    return _precioNoche * _numeroDias;
  }

  @override
  Widget build(BuildContext context) {
    if (_numeroDias <= 0) {
      return const SizedBox.shrink();
    }

    return Card(
      color: Colors.blue.shade50,
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Resumen de Costos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCostRow(
              'Precio por noche',
              '\$${_precioNoche.toStringAsFixed(2)}',
              isSubtotal: true,
            ),
            const SizedBox(height: 8),
            _buildCostRow('Número de noches', '$_numeroDias', isSubtotal: true),
            const Divider(height: 20),
            _buildCostRow(
              'Total',
              '\$${_totalCalculado.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(
    String label,
    String value, {
    bool isSubtotal = false,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 18 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            color: isSubtotal ? Colors.grey[700] : Colors.black,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 24 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            color: isTotal ? Colors.blue : Colors.black87,
          ),
        ),
      ],
    );
  }
}

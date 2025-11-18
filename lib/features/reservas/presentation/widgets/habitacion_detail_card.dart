// lib/features/reservas/presentation/widgets/habitacion_detail_card.dart

import 'package:flutter/material.dart';
import '../../../habitaciones/data/models/habitacion_model.dart';

class HabitacionDetailCard extends StatelessWidget {
  final HabitacionModel habitacion;

  const HabitacionDetailCard({super.key, required this.habitacion});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Habitación ${habitacion.numero}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              habitacion.tipo.toUpperCase(),
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
            const Divider(height: 24),
            _buildDetailRow(Icons.square_foot, 'Tamaño', habitacion.tamanio),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.people,
              'Capacidad',
              '${habitacion.capacidad} personas',
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              Icons.attach_money,
              'Precio por noche',
              '\$${habitacion.precioNoche}',
            ),
            if (habitacion.descripcion.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                habitacion.descripcion,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    );
  }
}

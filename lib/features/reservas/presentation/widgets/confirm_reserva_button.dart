// lib/features/reservas/presentation/widgets/confirm_reserva_button.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../habitaciones/data/models/habitacion_model.dart';
import '../providers/reserva_provider.dart';

class ConfirmReservaButton extends StatelessWidget {
  final HabitacionModel habitacion;
  final DateTime? fechaEntrada;
  final DateTime? fechaSalida;
  final VoidCallback? onSuccess;

  const ConfirmReservaButton({
    super.key,
    required this.habitacion,
    required this.fechaEntrada,
    required this.fechaSalida,
    this.onSuccess,
  });

  int get _numeroDias {
    if (fechaEntrada == null || fechaSalida == null) return 0;
    return fechaSalida!.difference(fechaEntrada!).inDays;
  }

  double get _totalCalculado {
    final precioNoche = double.tryParse(habitacion.precioNoche) ?? 0.0;
    return precioNoche * _numeroDias;
  }

  Future<void> _confirmarReserva(BuildContext context) async {
    if (fechaEntrada == null || fechaSalida == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona las fechas de entrada y salida'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_numeroDias <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('La fecha de salida debe ser posterior a la entrada'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final provider = context.read<ReservaProvider>();
    final success = await provider.createReserva(
      habitacionId: habitacion.id!,
      hotelId: habitacion.hotel,
      fechaEntrada: fechaEntrada!,
      fechaSalida: fechaSalida!,
      total: _totalCalculado,
      huespedId: 2, // ID hardcodeado
    );

    if (!context.mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('¡Reserva creada exitosamente!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );

      if (onSuccess != null) {
        onSuccess!();
      } else {
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(provider.errorMessage ?? 'Error al crear la reserva'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReservaProvider>(
      builder: (context, provider, child) {
        final isEnabled = _numeroDias > 0 && !provider.isLoading;

        return SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: isEnabled ? () => _confirmarReserva(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child:
                provider.isLoading
                    ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                    : const Text(
                      'Confirmar Reserva',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        );
      },
    );
  }
}

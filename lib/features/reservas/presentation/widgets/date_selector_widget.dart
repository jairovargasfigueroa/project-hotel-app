// lib/features/reservas/presentation/widgets/date_selector_widget.dart

import 'package:flutter/material.dart';

class DateSelectorWidget extends StatelessWidget {
  final String label;
  final DateTime? fecha;
  final Function(DateTime) onDateSelected;
  final bool enabled;
  final DateTime? minDate;

  const DateSelectorWidget({
    super.key,
    required this.label,
    required this.fecha,
    required this.onDateSelected,
    this.enabled = true,
    this.minDate,
  });

  Future<void> _selectDate(BuildContext context) async {
    if (!enabled) return;

    final DateTime firstDate = minDate ?? DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: fecha ?? firstDate,
      firstDate: firstDate,
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? () => _selectDate(context) : null,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: enabled ? Colors.grey : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
          color: enabled ? Colors.white : Colors.grey.shade100,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: enabled ? Colors.blue : Colors.grey,
                ),
                const SizedBox(width: 12),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: enabled ? Colors.black87 : Colors.grey,
                  ),
                ),
              ],
            ),
            Text(
              fecha != null
                  ? '${fecha!.day.toString().padLeft(2, '0')}/${fecha!.month.toString().padLeft(2, '0')}/${fecha!.year}'
                  : 'Seleccionar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    enabled
                        ? (fecha != null ? Colors.blue : Colors.grey)
                        : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// lib/features/hoteles/presentation/widgets/hotel_selector_dropdown.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/models/hotel_model.dart';
import '../providers/hotels_provider.dart';

class HotelSelectorDropdown extends StatelessWidget {
  const HotelSelectorDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HotelsProvider>(
      builder: (context, provider, child) {
        return DropdownButtonFormField<HotelModel>(
          decoration: InputDecoration(
            labelText: 'Hotel',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            prefixIcon: const Icon(Icons.hotel),
          ),
          value: provider.selectedHotel,
          hint: const Text('Seleccione un hotel'),
          isExpanded: true,
          items:
              provider.hotelesActivos.map((hotel) {
                return DropdownMenuItem<HotelModel>(
                  value: hotel,
                  child: Text(hotel.nombre, overflow: TextOverflow.ellipsis),
                );
              }).toList(),
          onChanged: (HotelModel? newHotel) {
            provider.selectHotel(newHotel);
          },
        );
      },
    );
  }
}

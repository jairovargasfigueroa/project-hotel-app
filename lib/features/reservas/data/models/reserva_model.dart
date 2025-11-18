// lib/features/reservas/data/models/reserva_model.dart

class ReservaModel {
  final int? id;
  final int habitacion;
  final int hotel;
  final String fechaEntrada;
  final String fechaSalida;
  final double total;
  final int huesped;

  ReservaModel({
    this.id,
    required this.habitacion,
    required this.hotel,
    required this.fechaEntrada,
    required this.fechaSalida,
    required this.total,
    required this.huesped,
  });

  factory ReservaModel.fromJson(Map<String, dynamic> json) {
    return ReservaModel(
      id: json['id'] as int?,
      habitacion: json['habitacion'] as int,
      hotel: json['hotel'] as int,
      fechaEntrada: json['fecha_entrada'] as String,
      fechaSalida: json['fecha_salida'] as String,
      total: (json['total'] as num).toDouble(),
      huesped: json['huesped'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'habitacion': habitacion,
      'hotel': hotel,
      'fecha_entrada': fechaEntrada,
      'fecha_salida': fechaSalida,
      'total': total,
      'huesped': huesped,
    };
  }

  ReservaModel copyWith({
    int? id,
    int? habitacion,
    int? hotel,
    String? fechaEntrada,
    String? fechaSalida,
    double? total,
    int? huesped,
  }) {
    return ReservaModel(
      id: id ?? this.id,
      habitacion: habitacion ?? this.habitacion,
      hotel: hotel ?? this.hotel,
      fechaEntrada: fechaEntrada ?? this.fechaEntrada,
      fechaSalida: fechaSalida ?? this.fechaSalida,
      total: total ?? this.total,
      huesped: huesped ?? this.huesped,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReservaModel &&
        other.id == id &&
        other.habitacion == habitacion &&
        other.hotel == hotel &&
        other.fechaEntrada == fechaEntrada &&
        other.fechaSalida == fechaSalida &&
        other.total == total &&
        other.huesped == huesped;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        habitacion.hashCode ^
        hotel.hashCode ^
        fechaEntrada.hashCode ^
        fechaSalida.hashCode ^
        total.hashCode ^
        huesped.hashCode;
  }

  @override
  String toString() {
    return 'ReservaModel(id: $id, habitacion: $habitacion, hotel: $hotel, fechaEntrada: $fechaEntrada, fechaSalida: $fechaSalida, total: $total, huesped: $huesped)';
  }
}

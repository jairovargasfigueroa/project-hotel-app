// lib/features/reservas/data/models/mi_reserva_model.dart

class MiReservaModel {
  final int id;
  final String fechaReserva;
  final String fechaEntrada;
  final String fechaSalida;
  final String total;
  final String estado;
  final int huesped;
  final String nombreHuesped;
  final int hotel;
  final String nombreHotel;
  final int habitacion;
  final String nroHabitacion;
  final String? checkin;
  final String? checkout;
  final String? folio;

  MiReservaModel({
    required this.id,
    required this.fechaReserva,
    required this.fechaEntrada,
    required this.fechaSalida,
    required this.total,
    required this.estado,
    required this.huesped,
    required this.nombreHuesped,
    required this.hotel,
    required this.nombreHotel,
    required this.habitacion,
    required this.nroHabitacion,
    this.checkin,
    this.checkout,
    this.folio,
  });

  factory MiReservaModel.fromJson(Map<String, dynamic> json) {
    return MiReservaModel(
      id: json['id'] as int,
      fechaReserva: json['fecha_reserva'] as String,
      fechaEntrada: json['fecha_entrada'] as String,
      fechaSalida: json['fecha_salida'] as String,
      total: json['total'] as String,
      estado: json['estado'] as String,
      huesped: json['huesped'] as int,
      nombreHuesped: json['nombre_huesped'] as String,
      hotel: json['hotel'] as int,
      nombreHotel: json['nombre_hotel'] as String,
      habitacion: json['habitacion'] as int,
      nroHabitacion: json['nro_habitacion'] as String,
      checkin: json['checkin'] as String?,
      checkout: json['checkout'] as String?,
      folio: json['folio'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fecha_reserva': fechaReserva,
      'fecha_entrada': fechaEntrada,
      'fecha_salida': fechaSalida,
      'total': total,
      'estado': estado,
      'huesped': huesped,
      'nombre_huesped': nombreHuesped,
      'hotel': hotel,
      'nombre_hotel': nombreHotel,
      'habitacion': habitacion,
      'nro_habitacion': nroHabitacion,
      'checkin': checkin,
      'checkout': checkout,
      'folio': folio,
    };
  }

  @override
  String toString() {
    return 'MiReservaModel(id: $id, hotel: $nombreHotel, habitacion: $nroHabitacion, estado: $estado, fechaEntrada: $fechaEntrada, fechaSalida: $fechaSalida)';
  }
}

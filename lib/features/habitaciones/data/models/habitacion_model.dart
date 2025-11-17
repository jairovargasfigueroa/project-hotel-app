// lib/features/habitaciones/data/models/habitacion_model.dart

class HabitacionModel {
  final int? id;
  final int hotel;
  final String numero;
  final String tipo;
  final String tamanio;
  final String capacidad;
  final String precioNoche;
  final String estado;
  final String descripcion;

  HabitacionModel({
    this.id,
    required this.hotel,
    required this.numero,
    required this.tipo,
    required this.tamanio,
    required this.capacidad,
    required this.precioNoche,
    required this.estado,
    required this.descripcion,
  });

  factory HabitacionModel.fromJson(Map<String, dynamic> json) {
    return HabitacionModel(
      id: json['id'] as int?,
      hotel: json['hotel'] as int,
      numero: json['numero'] as String,
      tipo: json['tipo'] as String,
      tamanio: json['tamanio'] as String,
      capacidad: json['capacidad'] as String,
      precioNoche: json['precio_noche'] as String,
      estado: json['estado'] as String,
      descripcion: json['descripcion'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hotel': hotel,
      'numero': numero,
      'tipo': tipo,
      'tamanio': tamanio,
      'capacidad': capacidad,
      'precio_noche': precioNoche,
      'estado': estado,
      'descripcion': descripcion,
    };
  }

  HabitacionModel copyWith({
    int? id,
    int? hotel,
    String? numero,
    String? tipo,
    String? tamanio,
    String? capacidad,
    String? precioNoche,
    String? estado,
    String? descripcion,
  }) {
    return HabitacionModel(
      id: id ?? this.id,
      hotel: hotel ?? this.hotel,
      numero: numero ?? this.numero,
      tipo: tipo ?? this.tipo,
      tamanio: tamanio ?? this.tamanio,
      capacidad: capacidad ?? this.capacidad,
      precioNoche: precioNoche ?? this.precioNoche,
      estado: estado ?? this.estado,
      descripcion: descripcion ?? this.descripcion,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HabitacionModel &&
        other.id == id &&
        other.hotel == hotel &&
        other.numero == numero &&
        other.tipo == tipo &&
        other.tamanio == tamanio &&
        other.capacidad == capacidad &&
        other.precioNoche == precioNoche &&
        other.estado == estado &&
        other.descripcion == descripcion;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        hotel.hashCode ^
        numero.hashCode ^
        tipo.hashCode ^
        tamanio.hashCode ^
        capacidad.hashCode ^
        precioNoche.hashCode ^
        estado.hashCode ^
        descripcion.hashCode;
  }

  @override
  String toString() {
    return 'HabitacionModel(id: $id, hotel: $hotel, numero: $numero, tipo: $tipo, tamanio: $tamanio, capacidad: $capacidad, precioNoche: $precioNoche, estado: $estado, descripcion: $descripcion)';
  }
}

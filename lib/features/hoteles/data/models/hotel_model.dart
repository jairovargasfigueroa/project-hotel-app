// lib/features/hoteles/data/models/hotel_model.dart

class HotelModel {
  final int? id;
  final String nombre;
  final String direccion;
  final String telefono;
  final String estado;

  HotelModel({
    this.id,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.estado,
  });

  // Crear instancia desde JSON
  factory HotelModel.fromJson(Map<String, dynamic> json) {
    return HotelModel(
      id: json['id'] as int?,
      nombre: json['nombre'] as String,
      direccion: json['direccion'] as String,
      telefono: json['telefono'] as String,
      estado: json['estado'] as String,
    );
  }

  // Convertir a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'estado': estado,
    };
  }

  // CopyWith para crear copias con cambios
  HotelModel copyWith({
    int? id,
    String? nombre,
    String? direccion,
    String? telefono,
    String? estado,
  }) {
    return HotelModel(
      id: id ?? this.id,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      estado: estado ?? this.estado,
    );
  }

  @override
  String toString() {
    return 'HotelModel(id: $id, nombre: $nombre, direccion: $direccion, telefono: $telefono, estado: $estado)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is HotelModel &&
        other.id == id &&
        other.nombre == nombre &&
        other.direccion == direccion &&
        other.telefono == telefono &&
        other.estado == estado;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        nombre.hashCode ^
        direccion.hashCode ^
        telefono.hashCode ^
        estado.hashCode;
  }
}

// lib/features/reservas/data/models/mis_reservas_response_model.dart

import 'mi_reserva_model.dart';

class UsuarioInfoModel {
  final int id;
  final String username;
  final String email;
  final String nombreCompleto;

  UsuarioInfoModel({
    required this.id,
    required this.username,
    required this.email,
    required this.nombreCompleto,
  });

  factory UsuarioInfoModel.fromJson(Map<String, dynamic> json) {
    return UsuarioInfoModel(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      nombreCompleto: json['nombre_completo'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'nombre_completo': nombreCompleto,
    };
  }
}

class MisReservasResponseModel {
  final UsuarioInfoModel usuario;
  final List<MiReservaModel> reservas;
  final int totalReservas;

  MisReservasResponseModel({
    required this.usuario,
    required this.reservas,
    required this.totalReservas,
  });

  factory MisReservasResponseModel.fromJson(Map<String, dynamic> json) {
    return MisReservasResponseModel(
      usuario: UsuarioInfoModel.fromJson(json['usuario'] as Map<String, dynamic>),
      reservas: (json['reservas'] as List<dynamic>)
          .map((reserva) => MiReservaModel.fromJson(reserva as Map<String, dynamic>))
          .toList(),
      totalReservas: json['total_reservas'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'usuario': usuario.toJson(),
      'reservas': reservas.map((r) => r.toJson()).toList(),
      'total_reservas': totalReservas,
    };
  }

  @override
  String toString() {
    return 'MisReservasResponseModel(usuario: ${usuario.nombreCompleto}, totalReservas: $totalReservas)';
  }
}

// lib/features/perfil/data/models/perfil_model.dart

class PerfilModel {
  final int id;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final String? photo;
  final String? photo_url;
  final String last_login;
  final bool is_admin;
  final List<dynamic> roles;
  final List<dynamic> permissions;

  PerfilModel({
    required this.id,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
    this.photo,
    this.photo_url,
    required this.last_login,
    required this.is_admin,
    required this.roles,
    required this.permissions,
  });

  factory PerfilModel.fromJson(Map<String, dynamic> json) {
    // Los datos del usuario vienen en json['user']
    final user = json['user'] as Map<String, dynamic>;
    
    return PerfilModel(
      id: user['id'] as int,
      username: user['username'] as String,
      email: user['email'] as String,
      first_name: user['first_name'] as String,
      last_name: user['last_name'] as String,
      photo: user['photo'] as String?,
      photo_url: json['photo_url'] as String?, // Este viene en el nivel superior
      last_login: json['last_login'] as String,
      is_admin: json['is_admin'] as bool,
      roles: json['roles'] as List<dynamic>,
      permissions: json['permissions'] as List<dynamic>,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': {
        'id': id,
        'username': username,
        'email': email,
        'first_name': first_name,
        'last_name': last_name,
        'photo': photo,
      },
      'photo_url': photo_url,
      'last_login': last_login,
      'is_admin': is_admin,
      'roles': roles,
      'permissions': permissions,
    };
  }

  PerfilModel copyWith({
    int? id,
    String? username,
    String? email,
    String? first_name,
    String? last_name,
    String? photo,
    String? photo_url,
    String? last_login,
    bool? is_admin,
    List<dynamic>? roles,
    List<dynamic>? permissions,
  }) {
    return PerfilModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      first_name: first_name ?? this.first_name,
      last_name: last_name ?? this.last_name,
      photo: photo ?? this.photo,
      photo_url: photo_url ?? this.photo_url,
      last_login: last_login ?? this.last_login,
      is_admin: is_admin ?? this.is_admin,
      roles: roles ?? this.roles,
      permissions: permissions ?? this.permissions,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PerfilModel &&
        other.id == id &&
        other.username == username &&
        other.email == email &&
        other.first_name == first_name &&
        other.last_name == last_name &&
        other.photo == photo &&
        other.photo_url == photo_url &&
        other.last_login == last_login &&
        other.is_admin == is_admin;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        username.hashCode ^
        email.hashCode ^
        first_name.hashCode ^
        last_name.hashCode ^
        photo.hashCode ^
        photo_url.hashCode ^
        last_login.hashCode ^
        is_admin.hashCode;
  }

  @override
  String toString() {
    return 'PerfilModel(id: $id, username: $username, email: $email, first_name: $first_name, last_name: $last_name, is_admin: $is_admin)';
  }
}


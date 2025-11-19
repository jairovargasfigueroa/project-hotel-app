// lib/features/auth/data/models/auth_models.dart

class LoginRequest {
  final String username;
  final String password;

  LoginRequest({required this.username, required this.password});

  Map<String, dynamic> toJson() => {'username': username, 'password': password};
}

class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final GuestUser user;
  final String message;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.message,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: GuestUser.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'refresh_token': refreshToken,
    'user': user.toJson(),
    'message': message,
  };
}

class GuestUser {
  final int id;
  final String username;
  final String email;
  final String? firstName;
  final String? lastName;
  final String? photoUrl;

  GuestUser({
    required this.id,
    required this.username,
    required this.email,
    this.firstName,
    this.lastName,
    this.photoUrl,
  });

  factory GuestUser.fromJson(Map<String, dynamic> json) {
    return GuestUser(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      photoUrl: json['photo_url'] as String?,
    );
  }

  String get fullName {
    if (firstName != null || lastName != null) {
      return '${firstName ?? ''} ${lastName ?? ''}'.trim();
    }
    return username;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'first_name': firstName,
    'last_name': lastName,
    'photo_url': photoUrl,
  };

  // CopyWith para crear copias con cambios
  GuestUser copyWith({
    int? id,
    String? username,
    String? email,
    String? firstName,
    String? lastName,
    String? photoUrl,
  }) {
    return GuestUser(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }
}

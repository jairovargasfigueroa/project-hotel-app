// lib/features/auth/data/models/register_models.dart

class RegisterRequest {
  final String username;
  final String password;
  final String email;
  final String? firstName;
  final String? lastName;

  RegisterRequest({
    required this.username,
    required this.password,
    required this.email,
    this.firstName,
    this.lastName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'username': username,
      'password': password,
      'email': email,
    };
    
    if (firstName != null && firstName!.isNotEmpty) {
      data['first_name'] = firstName;
    }
    
    if (lastName != null && lastName!.isNotEmpty) {
      data['last_name'] = lastName;
    }
    
    return data;
  }
}

class RegisteredUser {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final List<String> groups;

  RegisteredUser({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.groups,
  });

  factory RegisteredUser.fromJson(Map<String, dynamic> json) {
    return RegisteredUser(
      id: json['id'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'groups': groups,
    };
  }

  String get fullName {
    if (firstName.isEmpty && lastName.isEmpty) return username;
    return '${firstName} ${lastName}'.trim();
  }

  String get role {
    if (groups.isEmpty) return 'Usuario';
    return groups.first;
  }
}

class RegisterResponse {
  final String accessToken;
  final String refreshToken;
  final RegisteredUser user;
  final String message;

  RegisterResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    required this.message,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) {
    return RegisterResponse(
      accessToken: json['access_token'] as String,
      refreshToken: json['refresh_token'] as String,
      user: RegisteredUser.fromJson(json['user'] as Map<String, dynamic>),
      message: json['message'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'user': user.toJson(),
      'message': message,
    };
  }
}

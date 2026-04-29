class UserModel {
  final int id;
  final String nombre;
  final String correo;
  final String celular;
  final String rol;

  UserModel({
    required this.id,
    required this.nombre,
    required this.correo,
    required this.celular,
    required this.rol,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      correo: json['correo'] ?? '',
      celular: json['celular'] ?? '',
      rol: json['rol_slug'] ?? json['rol'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'nombre': nombre,
    'correo': correo,
    'celular': celular,
    'rol_slug': rol,
  };
}

class AuthResponse {
  final String accessToken;
  final String tokenType;
  final UserModel user;

  AuthResponse({
    required this.accessToken,
    required this.tokenType,
    required this.user,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? 'Bearer',
      user: UserModel.fromJson(json['user'] ?? {}),
    );
  }
}

import '../../domain/entities/user_model.dart';

class UserResponse extends UserModel {
  const UserResponse({
    super.id,
    required super.email,
    required super.sessionId,
    super.name,
    super.phone,
    super.role,
    super.gender,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) => UserResponse(
    id: json['id'],
    email: json['email'],
    sessionId: json['sessionId'],
    name: json['name'],
    phone: json['phone'],
    role: json['role'],
    gender: json['gender'],
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'sessionId': sessionId,
    'name': name,
    'phone': phone,
    'role': role?.value,
    'gender': gender?.value,
  };

  UserResponse.fromEntity(UserModel entity)
    : this(
        id: entity.id,
        sessionId: entity.sessionId,
        email: entity.email,
        name: entity.name,
        phone: entity.phone,
        role: entity.role,
        gender: entity.gender,
      );

  UserModel toEntity() => UserResponse(
    id: id,
    sessionId: sessionId,
    email: email,
    name: name,
    phone: phone,
    role: role,
    gender: gender,
  );
}

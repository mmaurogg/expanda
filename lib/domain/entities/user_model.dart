enum Gender {
  male('male'),
  female('female'),
  other('other'),
  notSpecified('notSpecified');

  final String value;

  const Gender(this.value);
}

enum Role {
  user('user'),
  teacher('teacher');

  final String value;

  const Role(this.value);
}

class UserModel {
  final String? id;
  final String sessionId;
  final String email;
  final String? name;
  final String? phone;
  final Role? role;
  final Gender? gender;

  const UserModel({
    this.id,
    required this.email,
    required this.sessionId,
    this.name,
    this.phone,
    this.role,
    this.gender,
  });

  UserModel copyWith({
    String? id,
    String? sessionId,
    String? email,
    String? name,
    String? phone,
    Role? role,
    Gender? gender,
  }) {
    return UserModel(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      gender: gender ?? this.gender,
    );
  }
}

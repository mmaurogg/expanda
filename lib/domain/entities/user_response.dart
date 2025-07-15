class UserResponse {
  final String id;
  final String email;
  final String? name;

  const UserResponse({required this.id, required this.email, this.name});

  UserResponse copyWith({String? id, String? email, String? name}) {
    return UserResponse(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
    );
  }
}

import '../../domain/entities/user_model.dart';

class UserResponse extends UserModel {
  const UserResponse({required String id, required String email, String? name})
    : super(id: id, email: email, name: name);

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      UserResponse(id: json['id'], email: json['email'], name: json['name']);
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'name': name,
  };
}

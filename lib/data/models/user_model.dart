import '../../domain/entities/user_response.dart';

class UserModel extends UserResponse {
  const UserModel({required String id, required String email, String? name})
    : super(id: id, email: email, name: name);

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      UserModel(id: json['id'], email: json['email'], name: json['name']);
  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'email': email,
    'name': name,
  };
}

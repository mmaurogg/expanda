import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expanda/data/datasources/api_source_firestore.dart';
import 'package:expanda/data/models/user_response.dart';
import 'package:expanda/domain/entities/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDataSourceProvider = Provider<UserApiSource>((ref) {
  final firestore = FirebaseFirestore.instance;
  return UserApiSource(firestore);
});

class UserApiSource extends ApiSourceFirestore {
  UserApiSource(super.firestore);

  //@override
  Future<UserModel?> getCurrentUser() {
    throw UnimplementedError();
  }

  //@override
  Future<UserModel?> saveUser(UserResponse user) async {
    await addFirestore<UserModel>(
      collection: 'users',
      json: user.toJson(),
    ).onError((error, stackTrace) {
      throw Exception('Error al guardar usuario: ${error.toString()}');
    });

    return user.toEntity();
  }
}

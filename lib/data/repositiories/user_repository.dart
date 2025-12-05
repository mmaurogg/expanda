import 'package:expanda/data/datasources/user_api_source.dart';
import 'package:expanda/data/models/user_response.dart';
import 'package:expanda/domain/entities/user_model.dart';
import 'package:expanda/domain/repositories/user_respository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userRepositoryProvider = Provider<UserRepository>((ref) {
  final remoteDataSource = ref.read(userDataSourceProvider);
  return UserRepositoryImpl(remoteDataSource);
});

class UserRepositoryImpl implements UserRepository {
  final UserApiSource _apiSource;

  UserRepositoryImpl(this._apiSource);

  @override
  Future<UserModel?> getCurrentUser() {
    return _apiSource.getCurrentUser();
  }

  @override
  Future<UserModel?> saveUser(UserModel user) {
    final userRes = UserResponse.fromEntity(user);
    return _apiSource.saveUser(userRes);
  }
}

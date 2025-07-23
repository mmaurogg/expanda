import 'package:expanda/data/datasources/auth_api_source.dart';
import 'package:expanda/data/models/user_response.dart';
import 'package:expanda/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final remoteDataSource = ref.read(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(remoteDataSource);
});

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserResponse?> get authStateChanges =>
      _remoteDataSource.authStateChanges;

  @override
  Future<UserResponse?> getCurrentUser() {
    return _remoteDataSource.getCurrentUser();
  }

  @override
  Future<UserResponse> login(String email, String password) {
    return _remoteDataSource.login(email, password);
  }

  @override
  Future<void> logout() {
    return _remoteDataSource.logout();
  }

  @override
  Future<UserResponse> register(String email, String password) {
    return _remoteDataSource.register(email, password);
  }

  @override
  Future<UserResponse> signInWithGoogle() {
    return _remoteDataSource.signInWithGoogle();
  }
}

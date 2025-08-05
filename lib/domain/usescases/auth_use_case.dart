import 'package:expanda/data/repositiories/auth_repository.dart';
import 'package:expanda/domain/entities/user_model.dart';
import 'package:expanda/domain/repositories/auth_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authUseCaseProvider = Provider<AuthUseCase>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthUseCase(authRepository);
});

class AuthUseCase {
  final AuthRepository _repository;

  AuthUseCase(this._repository);

  Stream<UserModel?> get authStateChanges => _repository.authStateChanges;

  Future<UserModel?> getCurrentUser() {
    return _repository.getCurrentUser();
  }

  Future<UserModel> login(String email, String password) {
    return _repository.login(email, password);
  }

  Future<void> logout() {
    return _repository.logout();
  }

  Future<UserModel> register(String email, String password) {
    return _repository.register(email, password);
  }

  Future<UserModel> signInWithGoogle() {
    return _repository.signInWithGoogle();
  }
}

import 'package:expanda/domain/entities/user_response.dart';

abstract class AuthRepository {
  Future<UserResponse> register(String email, String password);
  Future<UserResponse> login(String email, String password);
  Future<UserResponse> signInWithGoogle();
  Future<void> logout();
  Future<UserResponse?> getCurrentUser();
  Stream<UserResponse?> get authStateChanges;
}

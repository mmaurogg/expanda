import 'package:expanda/domain/entities/user_model.dart';

abstract class AuthRepository {
  Future<UserModel> register(String email, String password);
  Future<UserModel> login(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<void> logout();
  Future<UserModel?> getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

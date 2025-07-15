import 'package:expanda/data/datasources/auth_api_source.dart';
import 'package:expanda/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expanda/domain/repositories/auth_repository.dart';

/* final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return AuthRepositoryImpl(firebaseAuth);
}); */

final authProvider = StateNotifierProvider<AuthNotifier, UserModel>(
  (ref) => AuthNotifier(),
);

class AuthNotifier extends StateNotifier<UserModel> {
  AuthNotifier() : super(UserModel(id: '', email: ''));

  final AuthRepository _authRepository = AuthRepositoryImpl(
    FirebaseAuth.instance,
  );

  Future<void> register(String email, String password) async {
    final userResponse = await _authRepository.register(email, password);
    state = UserModel(id: userResponse.id, email: userResponse.email);
  }

  Future<void> login(String email, String password) async {
    final userResponse = await _authRepository.login(email, password);
    state = UserModel(id: userResponse.id, email: userResponse.email);
  }

  Future<void> logout() async {
    await _authRepository.logout();
    state = UserModel(id: '', email: '');
  }
}

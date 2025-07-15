import 'package:expanda/domain/entities/user_response.dart';
import 'package:expanda/domain/repositories/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl(this._firebaseAuth);

  @override
  Future<UserResponse> register(String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return UserResponse(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<UserResponse> login(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;
    return UserResponse(id: user.uid, email: user.email ?? '');
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}

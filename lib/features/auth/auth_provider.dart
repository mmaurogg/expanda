import 'package:expanda/data/datasources/auth_api_source.dart';
import 'package:expanda/data/models/user_model.dart';
import 'package:expanda/domain/entities/user_response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expanda/domain/repositories/auth_repository.dart';
import 'package:google_sign_in/google_sign_in.dart';

/* final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  return AuthRepositoryImpl(firebaseAuth);
}); */

/* final authProvider = StateNotifierProvider<AuthNotifier, UserModel>(
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
 */

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final googleSignInProvider = Provider<GoogleSignIn>(
  //(ref) => GoogleSignIn.instance,
  (ref) => GoogleSignIn(),
);

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final googleSignIn = ref.read(googleSignInProvider);
  return AuthRepositoryImpl(firebaseAuth, googleSignIn);
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  return AuthNotifier(authRepository);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(AuthState.initial()) {
    _init();
  }

  void _init() {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  Future<void> register(String email, String password) async {
    state = AuthState.loading();
    try {
      final user = await _authRepository.register(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    try {
      final user = await _authRepository.signInWithGoogle();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      final user = await _authRepository.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    state = AuthState.loading();
    try {
      await _authRepository.logout();
      state = AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(_getErrorMessage(e));
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  String _getErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No se encontró un usuario con este email.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        case 'email-already-in-use':
          return 'Este email ya está registrado.';
        case 'weak-password':
          return 'La contraseña es muy débil.';
        case 'invalid-email':
          return 'El email no es válido.';
        default:
          return 'Error de autenticación: ${error.message}';
      }
    }
    return 'Error inesperado: ${error.toString()}';
  }
}

class AuthState {
  final bool isLoading;
  final UserResponse? user;
  final String? error;
  final bool isAuthenticated;

  const AuthState._({
    this.isLoading = false,
    this.user,
    this.error,
    this.isAuthenticated = false,
  });

  factory AuthState.initial() => const AuthState._();

  factory AuthState.loading() => const AuthState._(isLoading: true);

  factory AuthState.authenticated(UserResponse user) =>
      AuthState._(user: user, isAuthenticated: true);

  factory AuthState.unauthenticated() =>
      const AuthState._(isAuthenticated: false);

  factory AuthState.error(String error) => AuthState._(error: error);

  AuthState copyWith({
    bool? isLoading,
    UserResponse? user,
    String? error,
    bool? isAuthenticated,
  }) {
    return AuthState._(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

import 'package:expanda/data/models/user_response.dart';
import 'package:expanda/domain/entities/user_model.dart';
import 'package:expanda/domain/usescases/auth_use_case.dart';
import 'package:expanda/domain/usescases/user_use_case.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authUseCase = ref.read(authUseCaseProvider);
  final userUseCase = ref.read(userUseCaseProvider);
  return AuthNotifier(authUseCase, userUseCase);
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthUseCase _authUseCase;
  final UserUseCase _userUseCase;

  AuthNotifier(this._authUseCase, this._userUseCase)
    : super(AuthState.initial()) {
    _init();
  }

  void _init() {
    _authUseCase.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = AuthState.unauthenticated();
      }
    });
  }

  Future<void> register(UserResponse newUser, String password) async {
    state = AuthState.loading();
    try {
      final userAuth = await _authUseCase.register(newUser.email, password);

      final user = newUser.copyWith(sessionId: userAuth.sessionId);

      await _userUseCase.saveUser(user);

      state = AuthState.authenticated(user);
    } catch (e) {
      print(e);
      state = AuthState.error(_getErrorMessage(e));
    }
  }

  Future<void> signInWithGoogle() async {
    state = AuthState.loading();
    try {
      final user = await _authUseCase.signInWithGoogle();
      state = AuthState.authenticated(user);
    } catch (e) {
      print(e);

      state = AuthState.error(_getErrorMessage(e));
    }
  }

  Future<void> login(String email, String password) async {
    state = AuthState.loading();
    try {
      final user = await _authUseCase.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      print(e);

      state = AuthState.error(_getErrorMessage(e));
    }
  }

  Future<void> logout() async {
    state = AuthState.loading();
    try {
      await _authUseCase.logout();
      state = AuthState.unauthenticated();
    } catch (e) {
      print(e);

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
  final UserModel? user;
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

  factory AuthState.authenticated(UserModel user) =>
      AuthState._(user: user, isAuthenticated: true);

  factory AuthState.unauthenticated() =>
      const AuthState._(isAuthenticated: false);

  factory AuthState.error(String error) => AuthState._(error: error);

  AuthState copyWith({
    bool? isLoading,
    UserModel? user,
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

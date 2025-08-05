import 'package:expanda/data/models/user_response.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);
final googleSignInProvider = Provider<GoogleSignIn>((ref) => GoogleSignIn());

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final firebaseAuth = ref.read(firebaseAuthProvider);
  final googleSignIn = ref.read(googleSignInProvider);
  return AuthRemoteDataSourceImpl(firebaseAuth, googleSignIn);
});

abstract class AuthRemoteDataSource {
  Future<UserResponse> login(String email, String password);
  Future<UserResponse> register(String email, String password);
  Future<UserResponse> signInWithGoogle();
  Future<void> logout();
  Future<UserResponse?> getCurrentUser();
  Stream<UserResponse?> get authStateChanges;
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl(this._firebaseAuth, this._googleSignIn);

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

  /* Future<void> _handleAuthenticationEvent(
    GoogleSignInAuthenticationEvent event,
  ) async {
    final GoogleSignInAccount? user = switch (event) {
      GoogleSignInAuthenticationEventSignIn() => event.user,
      GoogleSignInAuthenticationEventSignOut() => null,
    };

    /* final GoogleSignInClientAuthorization? authorization = await user
        ?.authorizationClient
        .authorizationForScopes(<String>[
          'email',
          'https://www.googleapis.com/auth/contacts.readonly',
        ]);
    // #enddocregion CheckAuthorization

    // If the user has already granted access to the required scopes, call the
    // REST API.
    if (user != null && authorization != null) {
      //_handleGetContact(user);
    } */
  } */

  @override
  Future<UserResponse> signInWithGoogle() async {
    try {
      /*  await _googleSignIn.initialize(
        //serverClientId:
        //'808793774900-ldeb9gd95vs3b2gofo241eobuejtjvsp.apps.googleusercontent.com',
      );

      var signIn = await _googleSignIn.authenticate();

      _googleSignIn.authenticationEvents
          .listen(
            //_handleAuthenticationEvent
            (e) {
              print(e);
            },
          )
          .onError((error) {
            print(error);
          });

      var googleUser = await _googleSignIn.attemptLightweightAuthentication(); */

      // Iniciar Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        throw Exception('Google Sign-In cancelado por el usuario');
      }

      // Obtener autenticación de Google
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Validar que los tokens no sean nulos
      if (googleAuth.accessToken == null || googleAuth.idToken == null) {
        throw Exception('Error al obtener tokens de Google');
      }

      // Crear credenciales para Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken!,
        idToken: googleAuth.idToken!,
      );

      // Iniciar sesión en Firebase
      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User user = userCredential.user!;

      return UserResponse(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
      );
    } catch (e) {
      throw Exception('Error en Google Sign-In: ${e.toString()}');
    }
    //return UserResponse(id: "", email: '', name: "");
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserResponse?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    return UserResponse(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
    );
  }

  @override
  Stream<UserResponse?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) return null;
      return UserResponse(
        id: user.uid,
        email: user.email ?? '',
        name: user.displayName,
      );
    });
  }
}

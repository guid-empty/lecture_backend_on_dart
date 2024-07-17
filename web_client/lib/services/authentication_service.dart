import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jsonwebtoken;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:web_client/logging/logger.dart';

class AuthenticationService {
  String? _token;

  auth.User? get currentUser => auth.FirebaseAuth.instance.currentUser;

  bool get isAuthenticated => currentUser != null;
  String? get token => _token;

  Future<void> initialize() async {
    _token = isAuthenticated ? await currentUser?.getIdToken() : null;
  }

  /// Если необходимо будет получить дополнительные данные от пользователя,
  /// нужно указать scopes и пройти вериикацию google
  /// ```
  ///       googleProvider
  ///           .addScope('https://www.googleapis.com/auth/contacts.readonly');
  /// ```
  Future<void> signInWithGoogle() async {
    auth.User? user;

    try {
      final googleProvider = auth.GoogleAuthProvider();

      final userCredential =
          await auth.FirebaseAuth.instance.signInWithPopup(googleProvider);

      user = userCredential.user;
      final token = _token = await user?.getIdToken();

      if (token != null) {
        final jwt = jsonwebtoken.JWT.decode(token);
        logger.debug(
            'decoded token is $jwt, user id is ${jwt.payload['user_id']}');
      }
    } catch (e, s) {
      logger.severe(e, e, s);
    }

    logger.info('Current user is $user');
  }

  Future<void> signOut() async {
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await auth.FirebaseAuth.instance.signOut();
      _token = null;
    }
  }
}

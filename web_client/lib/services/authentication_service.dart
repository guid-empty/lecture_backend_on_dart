import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:web_client/logging/logger.dart';

class AuthenticationService {
  auth.User? get currentUser => auth.FirebaseAuth.instance.currentUser;

  bool get isAuthenticated => currentUser != null;

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
    } catch (e, s) {
      logger.severe(e, e, s);
    }

    logger.info('Current use is $user');
  }

  Future<void> signOut() async {
    final firebaseUser = auth.FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await auth.FirebaseAuth.instance.signOut();
    }
  }
}

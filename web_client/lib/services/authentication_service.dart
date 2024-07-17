import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jsonwebtoken;
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:uuid/uuid.dart';
import 'package:web_client/logging/logger.dart';
import 'package:web_client/services/realtime_gateway.dart';

class AuthenticationService {
  final RealtimeGateway _realtimeGateway;
  final String windowKey = const Uuid().v4();
  String? _token;

  AuthenticationService({required RealtimeGateway realtimeGateway})
      : _realtimeGateway = realtimeGateway;

  auth.User? get currentUser => auth.FirebaseAuth.instance.currentUser;

  bool get isAuthenticated => currentUser != null;
  String? get token => _token;

  Future<void> initialize() async {
    _token = isAuthenticated ? await currentUser?.getIdToken() : null;
    if (isAuthenticated) {
      /// ======================================================================
      /// sessionId содержит два идентификатора - userId + Id окна браузера,
      /// разделенные символом ":"

      final userId = currentUser?.uid ?? 'unknown';
      final sessionId = '$userId:$windowKey';
      await _initRealtimeGateway(sessionId: sessionId);

      /// ======================================================================
    }
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
      final userId = user?.uid ?? 'unknown';

      /// ======================================================================
      /// sessionId содержит два идентификатора - userId + Id окна браузера,
      /// разделенные символом ":"
      final sessionId = '$userId:$windowKey';
      await _initRealtimeGateway(sessionId: sessionId);

      /// ======================================================================

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

  /// sessionId содержит два идентификатора - userId + Id окна браузера,
  /// разделенные символом ":"
  Future<void> _initRealtimeGateway({
    required String sessionId,
  }) async {
    await _realtimeGateway.connect(sessionId: sessionId);
  }
}

import 'package:app_server/src/logging/logger.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart' as jsonwebtoken;
import 'package:firebase_admin/firebase_admin.dart' as firebase_admin;
import 'package:shelf/shelf.dart';

abstract class AuthenticationCheckMiddleware {
  static Middleware createAuthenticationCheckMiddleware({
    required firebase_admin.App? firebaseAdminSDKApp,
  }) {
    return (Handler innerHandler) {
      return (Request request) async {
        try {
          logger.info('Checking the request ${request.requestedUri}');

          if (request.headers.containsKey('jwt_token')) {
            final token = request.headers['jwt_token'];
            if (token == null || token.isEmpty) {
              logger.severe('Token is invalid');
              return _getUnauthorizedResponse(request);
            }

            /// Если бы мы сами выпустили наш JWT,
            /// то могли бы проверить его подпись самостоятельно
            /// Если чтото пойдет не так, получим JWTExpiredException,
            /// JWTException, JWTInvalidException
            if (firebaseAdminSDKApp == null) {
              try {
                jsonwebtoken.JWT.verify(
                  token,
                  jsonwebtoken.SecretKey('Наш секретный ключ на сервере'),
                );
              } catch (_) {
                logger.severe('Token is not valid / $token');
                return _getUnauthorizedResponse(request);
              }
            } else {
              final idToken =
                  await firebaseAdminSDKApp.auth().verifyIdToken(token);
              if (!(idToken.isVerified ?? false)) {
                logger.severe('Token is not valid / $token');
                return _getUnauthorizedResponse(request);
              }

              final userId = idToken.claims['user_id'];
              request = request.change(
                context: {
                  ...request.context,
                  'user_id': userId,
                },
              );
            }
          } else if (!(request.url.path.contains('ws/connect') ||
              request.url.path.contains('benchmark'))) {
            return _getUnauthorizedResponse(request);
          }
        } catch (_) {
          return Response.badRequest();
        }

        final response = await innerHandler(request);
        return response.change(
          headers: {
            'server-on-dart': 'it\'s all ok',
          },
        );
      };
    };
  }

  static Response _getUnauthorizedResponse(Request request) =>
      Response.unauthorized(
        'Request ${request.handlerPath} is not authorized',
      );
}

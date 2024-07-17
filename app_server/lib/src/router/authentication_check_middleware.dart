import 'package:app_server/src/logging/logger.dart';
import 'package:shelf/shelf.dart';

abstract class AuthenticationCheckMiddleware {
  static Middleware createAuthenticationCheckMiddleware() {
    return (Handler innerHandler) {
      return (Request request) async {
        try {
          if (request.headers.containsKey('provider_user_id')) {
            final userId = request.headers['provider_user_id'];

            logger.info(
              'Checking the request ${request.requestedUri}, '
              'userId is $userId',
            );
            request = request.change(
              context: {
                ...request.context,
                'user_id': userId,
              },
            );
          } else {
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

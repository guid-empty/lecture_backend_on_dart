import 'package:dio/dio.dart';
import 'package:web_client/api/todo_api.dart';
import 'package:web_client/data/todo_repository.dart';
import 'package:web_client/services/authentication_service.dart';
import 'package:web_client/services/realtime_gateway.dart';

class DI {
  static AuthenticationService authenticationService =
      AuthenticationService(realtimeGateway: realtimeGateway);

  static RealtimeGateway realtimeGateway = RealtimeGateway();

  static TodoRepository todoRepository = TodoRepository(
    todoApi: TodoApi(
      dio: dio,
    ),
  );

  static Dio get dio {
    final dio = Dio();
    assert(
      () {
        dio.interceptors.add(
          LogInterceptor(
            responseBody: true,
            requestBody: true,
          ),
        );
        return true;
      }(),
      '',
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.headers['jwt_token'] = authenticationService.token;

          handler.next(options);
        },
      ),
    );

    return dio;
  }
}

import 'package:dio/dio.dart';
import 'package:web_client/data/todo_api.dart';
import 'package:web_client/data/todo_repository.dart';
import 'package:web_client/services/authentication_service.dart';

class DI {
  static AuthenticationService authenticationService = AuthenticationService();

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

    return dio;
  }
}

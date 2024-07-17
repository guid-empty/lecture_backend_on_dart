import 'package:dio/dio.dart';

class UserSessionApi {
  final Dio _dio;

  UserSessionApi({required Dio dio}) : _dio = dio;

  Future<void> connect(String session) async {}
}

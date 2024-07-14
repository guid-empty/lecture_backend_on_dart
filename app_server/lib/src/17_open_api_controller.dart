import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_open_api/shelf_open_api.dart';
import 'package:shelf_router/shelf_router.dart';

part '17_open_api_controller.g.dart';

class OrderController {
  Router get router => _$OrderControllerRouter(this);

  ///
  /// Создает заказ на основе пепреданного сообщения [CreateOrderQueryDto]
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.post('/order')
  @OpenApiRoute(requestBody: CreateOrderQueryDto)
  Future<Response> createOrder(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'price': 300.0}));

  ///
  /// Удаляет заказ по id, указанный в схеме маршрута через [orderId]
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.delete('/order/<orderId>')
  @OpenApiRoute()
  Future<Response> deleteOrder(Request request) async => Response.ok('');

  ///
  /// Возвращает полный список заказов
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.get('/order')
  @OpenApiRoute()
  Future<Response> getOrderList(Request request) async => Response.ok(
      jsonEncode(
        [
          {'id': 1, 'price ': 100.0},
          {'id': 2, 'price': 200.0},
        ],
      ),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'});

  ///
  /// Обновляет заказ по id, указанный в схеме маршрута через [orderId]
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.put('/order/<orderId>')
  @OpenApiRoute()
  Future<Response> updateOrder(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'price': 300.0}));
}

class UserController {
  Router get router => _$UserControllerRouter(this);

  ///
  /// Создает заказа на основе пепреданного сообщения [CreateUserQueryDto]
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.post('/user')
  @OpenApiRoute()
  Future<Response> createUser(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'name ': 'John'}));

  ///
  /// Удаляет пользователя по id, указанном в схеме маршрута через [userId]
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.delete('/user/<userId>')
  @OpenApiRoute()
  Future<Response> deleteUser(Request request) async => Response.ok('');

  ///
  /// Возвращает полный список пользователей
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.get('/user')
  @OpenApiRoute()
  Future<Response> getUserList(Request request) async => Response.ok(
        jsonEncode(
          [
            {'id': 1, 'name': 'John'},
            {'id': 2, 'name': 'Don'},
          ],
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );
  ///
  /// Обновляет пользователя по id, указанный в схеме маршрута через [userId]
  ///
  /// Возвращает 200, если все ок, в противном случае вернет код ошибки
  ///
  @Route.put('/user/<userId>')
  @OpenApiRoute()
  Future<Response> updateUser(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'name ': 'John'}));
}

class CreateOrderQueryDto {
  ///
  /// Order price
  ///
  final double price;

  const CreateOrderQueryDto({
    required this.price,
  });
}

class CreateUserQueryDto {
  ///
  /// User name
  ///
  final String name;

  const CreateUserQueryDto({
    required this.name,
  });
}

import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

part '16_domain_controller.g.dart';

class OrderController {
  Router get router => _$OrderControllerRouter(this);

  @Route.post('/order')
  Future<Response> createOrder(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'price': 300.0}));

  @Route.delete('/order/<orderId>')
  Future<Response> deleteOrder(Request request) async => Response.ok('');

  @Route.get('/order')
  Future<Response> getOrderList(Request request) async => Response.ok(
      jsonEncode(
        [
          {'id': 1, 'price ': 100.0},
          {'id': 2, 'price': 200.0},
        ],
      ),
      headers: {HttpHeaders.contentTypeHeader: 'application/json'});

  @Route.put('/order/<orderId>')
  Future<Response> updateOrder(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'price': 300.0}));
}

class UserController {
  Router get router => _$UserControllerRouter(this);

  @Route.post('/user')
  Future<Response> createUser(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'name ': 'John'}));

  @Route.delete('/user/<userId>')
  Future<Response> deleteUser(Request request) async => Response.ok('');

  @Route.get('/user')
  Future<Response> getUserList(Request request) async => Response.ok(
        jsonEncode(
          [
            {'id': 1, 'name': 'John'},
            {'id': 2, 'name': 'Don'},
          ],
        ),
        headers: {HttpHeaders.contentTypeHeader: 'application/json'},
      );

  @Route.put('/user/<userId>')
  Future<Response> updateUser(Request request) async =>
      Response.ok(jsonEncode({'id': 1, 'name ': 'John'}));
}

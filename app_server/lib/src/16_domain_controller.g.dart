// GENERATED CODE - DO NOT MODIFY BY HAND

part of '16_domain_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$OrderControllerRouter(OrderController service) {
  final router = Router();
  router.add(
    'POST',
    r'/order',
    service.createOrder,
  );
  router.add(
    'DELETE',
    r'/order/<orderId>',
    service.deleteOrder,
  );
  router.add(
    'GET',
    r'/order',
    service.getOrderList,
  );
  router.add(
    'PUT',
    r'/order/<orderId>',
    service.updateOrder,
  );
  return router;
}

Router _$UserControllerRouter(UserController service) {
  final router = Router();
  router.add(
    'POST',
    r'/user',
    service.createUser,
  );
  router.add(
    'DELETE',
    r'/user/<userId>',
    service.deleteUser,
  );
  router.add(
    'GET',
    r'/user',
    service.getUserList,
  );
  router.add(
    'PUT',
    r'/user/<userId>',
    service.updateUser,
  );
  return router;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_session_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$UserSessionControllerRouter(UserSessionController service) {
  final router = Router();
  router.add(
    'GET',
    r'/ws/connect/<token>',
    service.connect,
  );
  return router;
}

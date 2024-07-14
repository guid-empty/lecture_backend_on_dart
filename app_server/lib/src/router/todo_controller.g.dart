// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$TodoControllerRouter(TodoController service) {
  final router = Router();
  router.add(
    'POST',
    r'/create',
    service.createTodo,
  );
  router.add(
    'DELETE',
    r'/todo/<todoId>',
    service.deleteTodo,
  );
  router.add(
    'GET',
    r'/todo',
    service.getTodoList,
  );
  router.add(
    'PUT',
    r'/todo/<todoId>',
    service.updateTodo,
  );
  return router;
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'benchmark_controller.dart';

// **************************************************************************
// ShelfRouterGenerator
// **************************************************************************

Router _$BenchmarkControllerRouter(BenchmarkController service) {
  final router = Router();
  router.add(
    'GET',
    r'/benchmark',
    service.createBenchmark,
  );
  return router;
}

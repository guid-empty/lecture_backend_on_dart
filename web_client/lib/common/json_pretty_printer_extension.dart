import 'dart:convert';

extension JsonPrettyPrinterExtension on Map<String, dynamic> {
  String prettyPrint() => const JsonEncoder.withIndent(' ').convert(this);
}

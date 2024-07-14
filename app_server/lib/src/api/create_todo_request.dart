import 'package:app_server/src/api/base_rest_api_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'create_todo_request.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
)
class CreateTodoRequest extends BaseRestApiRequest {
  @JsonKey(name: 'is_completed')
  final bool isCompleted;

  @JsonKey(name: 'title')
  final String title;

  factory CreateTodoRequest.fromJson(Map<String, dynamic> data) =>
      _$CreateTodoRequestFromJson(data);

  CreateTodoRequest({
    required this.isCompleted,
    required this.title,
  });

  @override
  Map<String, dynamic> toJson() => _$CreateTodoRequestToJson(this);
}

import 'package:app_server/src/api/base_rest_api_request.dart';
import 'package:json_annotation/json_annotation.dart';

part 'update_todo_request.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
)
class UpdateTodoRequest extends BaseRestApiRequest {
  @JsonKey(name: 'is_completed')
  final bool isCompleted;

  @JsonKey(name: 'title')
  final String title;

  UpdateTodoRequest({
    required this.isCompleted,
    required this.title,
  });

  factory UpdateTodoRequest.fromJson(Map<String, dynamic> data) =>
      _$UpdateTodoRequestFromJson(data);

  @override
  Map<String, dynamic> toJson() => _$UpdateTodoRequestToJson(this);
}

import 'package:json_annotation/json_annotation.dart';

part 'base_rest_api_request.g.dart';

@JsonSerializable(
  createFactory: true,
  createToJson: true,
)
class BaseRestApiRequest {
  factory BaseRestApiRequest.fromJson(Map<String, dynamic> data) =>
      _$BaseRestApiRequestFromJson(data);

  Map<String, dynamic> toJson() => _$BaseRestApiRequestToJson(this);

  BaseRestApiRequest();
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'update_todo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateTodoRequest _$UpdateTodoRequestFromJson(Map<String, dynamic> json) =>
    UpdateTodoRequest(
      isCompleted: json['is_completed'] as bool,
      title: json['title'] as String,
    );

Map<String, dynamic> _$UpdateTodoRequestToJson(UpdateTodoRequest instance) =>
    <String, dynamic>{
      'is_completed': instance.isCompleted,
      'title': instance.title,
    };

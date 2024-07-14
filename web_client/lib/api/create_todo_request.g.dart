// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_todo_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateTodoRequest _$CreateTodoRequestFromJson(Map<String, dynamic> json) =>
    CreateTodoRequest(
      isCompleted: json['is_completed'] as bool,
      title: json['title'] as String,
    );

Map<String, dynamic> _$CreateTodoRequestToJson(CreateTodoRequest instance) =>
    <String, dynamic>{
      'is_completed': instance.isCompleted,
      'title': instance.title,
    };

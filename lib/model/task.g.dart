// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task.dart';

// **************************
// JsonSerializableGenerator
// **************************

Task _$TaskFromJson(Map<String, dynamic> json) {
  return Task(json['name'] as String,
      // imageName: json['imageName'] as String,
      color: json['color'] as int,
      //codePoint: json['code_point'] as int,
      id: json['id'] as String);
}

Map<String, dynamic> _$TaskToJson(Task instance) => <String, dynamic>{
      'id': instance.id,
      // 'imageName': instance.imageName,
      'name': instance.name,
      'color': instance.color,
      //'code_point': instance.codePoint
    };

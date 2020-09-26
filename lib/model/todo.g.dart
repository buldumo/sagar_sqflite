/// A necessary factory constructor for creating a new User instance
/// from a map. Pass the map to the generated `_$TodoFromJson()` constructor.
/// The constructor is named after the source class, in this case User.
// factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

/// `toJson` is the convention for a class to declare support for serialization
/// to JSON. The implementation simply calls the private, generated
/// helper method `_$TodoFromJson`.
// Map<String, dynamic> toJson() => _$TodoToJson(this);
//}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************
// JsonSerializableGenerator
// **************************

Todo _$TodoFromJson(Map<String, dynamic> json) {
  return Todo(json['name'] as String,
      parent: json['parent'] as String,
      isCompleted: json['completed'] as int,
      id: json['id'] as String);
}

Map<String, dynamic> _$TodoToJson(Todo instance) => <String, dynamic>{
      'id': instance.id,
      'parent': instance.parent,
      'name': instance.name,
      'completed': instance.isCompleted
    };

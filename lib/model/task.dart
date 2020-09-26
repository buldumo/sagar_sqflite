// import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';

// @JsonSerializable()
// class Task {
//   String id;
//   String name;
//   int color;

//   Task(this.name, {this.id, this.color});

//   factory Task.fromJson(Map<String, dynamic> json) {
//     return Task(
//       json['name'] as String,
//       id: json['id'] as String,
//       color: json['color'] as int,
//     );
//   }

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'name': name,
//         'color': color,
//       };
// }

import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:sagar_sqflite/util/uuid.dart';

part 'task.g.dart';

@JsonSerializable()
class Task {
  String id;
  String name;
  // String imageName;
  //Background Color
  int color;
  //@JsonKey(name: 'code_point')
  //int codePoint;

  Task(
    this.name, {
    // @required this.imageName,
    @required this.color,
    //@required this.codePoint,
    String id,
  }) : this.id = id ?? Uuid().generateV4();

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$TaskFromJson()` constructor.
  /// The constructor is named after the source class, in this case User.
  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$TaskFromJson`.
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

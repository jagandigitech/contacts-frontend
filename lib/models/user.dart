import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserResponse {
  final bool status;
  final String message;
  final UserData data;

  UserResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}

@JsonSerializable()
class UserData {
  final int id;
  final String fullname;
  final String username;
  final String createdDate;

  UserData({
    required this.id,
    required this.fullname,
    required this.username,
    required this.createdDate,
  });

  factory UserData.fromJson(Map<String, dynamic> json) =>
      _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

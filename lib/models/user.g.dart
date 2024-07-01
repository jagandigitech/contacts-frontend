// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserResponse _$UserResponseFromJson(Map<String, dynamic> json) => UserResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: UserData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserResponseToJson(UserResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: (json['id'] as num).toInt(),
      fullname: json['fullname'] as String,
      username: json['username'] as String,
      createdDate: json['createdDate'] as String,
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'fullname': instance.fullname,
      'username': instance.username,
      'createdDate': instance.createdDate,
    };

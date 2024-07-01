// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Contact _$ContactFromJson(Map<String, dynamic> json) => Contact(
      id: (json['id'] as num).toInt(),
      contactName: json['contactName'] as String,
      mobileNumber: json['mobileNumber'] as String,
      userId: (json['userId'] as num).toInt(),
    );

Map<String, dynamic> _$ContactToJson(Contact instance) => <String, dynamic>{
      'id': instance.id,
      'contactName': instance.contactName,
      'mobileNumber': instance.mobileNumber,
      'userId': instance.userId,
    };

ContactListResponse _$ContactListResponseFromJson(Map<String, dynamic> json) =>
    ContactListResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Contact.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ContactListResponseToJson(
        ContactListResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

CreateContactResponse _$CreateContactResponseFromJson(
        Map<String, dynamic> json) =>
    CreateContactResponse(
      status: json['status'] as bool,
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : Contact.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CreateContactResponseToJson(
        CreateContactResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

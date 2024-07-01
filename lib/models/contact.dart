import 'package:json_annotation/json_annotation.dart';

part 'contact.g.dart';

@JsonSerializable()
class Contact {
  final int id;
  final String contactName;
  final String mobileNumber;
  final int userId;

  Contact({
    required this.id,
    required this.contactName,
    required this.mobileNumber,
    required this.userId,
  });

  factory Contact.fromJson(Map<String, dynamic> json) =>
      _$ContactFromJson(json);
  Map<String, dynamic> toJson() => _$ContactToJson(this);
}

@JsonSerializable()
class ContactListResponse {
  final bool status;
  final String message;
  final List<Contact> data;

  ContactListResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ContactListResponse.fromJson(Map<String, dynamic> json) =>
      _$ContactListResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ContactListResponseToJson(this);
}

@JsonSerializable()
class CreateContactResponse {
  final bool status;
  final String message;
  final Contact? data;

  CreateContactResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory CreateContactResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateContactResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CreateContactResponseToJson(this);
}

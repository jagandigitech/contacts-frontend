import 'package:first_flutter_application_1/models/contact.dart';
import 'package:first_flutter_application_1/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'contact_provider.g.dart';

@riverpod
class ContactNotifier extends _$ContactNotifier {
  static const contactApiEndpointUrl =
      "https://contactdemo.jagandigitech.in/api/Contact";
  @override
  Future<List<Contact>> build() async {
    return fetchContacts();
  }

  Future<List<Contact>> fetchContacts() async {
    var userId = ref.read(authProvider.notifier).userId!;
    final response =
        await http.get(Uri.parse("$contactApiEndpointUrl/$userId"));
    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final contactListResponse = ContactListResponse.fromJson(jsonResponse);
      return contactListResponse.data;
    } else {
      throw Exception('Failed to load contacts');
    }
  }

  Future<void> addContact(Contact contact) async {
    state = const AsyncLoading();
    try {
      final response = await http.post(
        Uri.parse("$contactApiEndpointUrl/Create"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(contact.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final contactResponse = CreateContactResponse.fromJson(jsonResponse);
        if (contactResponse.status == true) {
          state = AsyncData([...state.value!, contactResponse.data!]);
        } else {
          throw Exception(contactResponse.message);
        }
      } else {
        throw Exception('Failed to add contact');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> updateContact(Contact contact) async {
    state = const AsyncLoading();
    try {
      final response = await http.post(
        Uri.parse("$contactApiEndpointUrl/Update"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(contact.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final contactResponse = CreateContactResponse.fromJson(jsonResponse);
        if (contactResponse.status == true) {
          state = AsyncData([
            for (final existingContact in state.value!)
              if (existingContact.id == contact.id)
                contact
              else
                existingContact,
          ]);
        }
      } else {
        throw Exception('Failed to update contact');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> deleteContact(int contactId, int userId) async {
    state = const AsyncLoading();
    try {
      final response = await http.post(
        Uri.parse("$contactApiEndpointUrl/Remove/$contactId/$userId"),
      );
      if (response.statusCode == 200) {
        state = AsyncData(
          state.value!
              .where((contact) =>
                  contact.id != contactId && contact.userId == userId)
              .toList(),
        );
      } else {
        throw Exception('Failed to delete contact');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }
}

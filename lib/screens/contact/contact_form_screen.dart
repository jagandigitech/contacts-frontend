import 'package:first_flutter_application_1/app_router.dart';
import 'package:first_flutter_application_1/models/contact.dart';
import 'package:first_flutter_application_1/providers/auth_provider.dart';
import 'package:first_flutter_application_1/providers/contact_provider.dart';
import 'package:first_flutter_application_1/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactFormScreen extends ConsumerStatefulWidget {
  final Contact? contact;
  const ContactFormScreen({super.key, this.contact});
  static String get routeName => 'contactForm';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<ContactFormScreen> createState() => _ContactFormScreenState();
}

class _ContactFormScreenState extends ConsumerState<ContactFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _contactName;
  late String _mobileNumber;
  late int _userId;

  @override
  void initState() {
    super.initState();
    _contactName = widget.contact?.contactName ?? '';
    _mobileNumber = widget.contact?.mobileNumber ?? '';
    _userId = widget.contact?.userId ?? ref.read(authProvider.notifier).userId!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.contact == null ? 'Add Contact' : 'Edit Contact',
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Dashboard',
              onPressed: () {
                context.go(DashboardScreen.routeLocation);
              },
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _contactName,
                decoration: const InputDecoration(
                  labelText: 'Contact Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a contact name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contactName = value!;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _mobileNumber,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile number';
                  }
                  return null;
                },
                onSaved: (value) {
                  _mobileNumber = value!;
                },
              ),
              // You can add more fields if needed
              const SizedBox(height: 20),
              SizedBox(
                width: 150,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      var contact = Contact(
                        id: widget.contact?.id ?? 0,
                        contactName: _contactName,
                        mobileNumber: _mobileNumber,
                        userId: _userId,
                      );
                      if (widget.contact == null) {
                        await ref
                            .read(contactNotifierProvider.notifier)
                            .addContact(contact);
                      } else {
                        await ref
                            .read(contactNotifierProvider.notifier)
                            .updateContact(contact);
                      }

                      if (mounted) {
                        ref.read(routerProvider).pop();
                        // Navigator.of(context).pop();
                      }
                    }
                  },
                  child: Text(widget.contact == null ? 'Create' : 'Update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

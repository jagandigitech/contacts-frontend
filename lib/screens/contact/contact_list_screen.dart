import 'package:first_flutter_application_1/common/alert_dialogs.dart';
import 'package:first_flutter_application_1/common/async_value_ui.dart';
import 'package:first_flutter_application_1/providers/contact_provider.dart';
import 'package:first_flutter_application_1/screens/contact/contact_form_screen.dart';
import 'package:first_flutter_application_1/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ContactListScreen extends ConsumerWidget {
  const ContactListScreen({super.key});

  static String get routeName => 'contactList';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final asyncContacts = ref.watch(contactNotifierProvider);

    ref.listen<AsyncValue>(
      contactNotifierProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    final state = ref.watch(contactNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Intern Contacts CRUD',
          style: TextStyle(color: Colors.white),
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
        padding: const EdgeInsets.all(12.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(contactNotifierProvider.future);
          },
          child: state.when(
            data: (contacts) => contacts.isEmpty
                ? const Center(child: Text('No contacts available'))
                : ListView.builder(
                    itemCount: contacts.length,
                    itemBuilder: (context, index) {
                      final contact = contacts[index];
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Card(
                          color: Colors.white,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                contact.contactName,
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green),
                              ),
                            ),
                            subtitle: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                contact.mobileNumber,
                                style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey),
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  color: Colors.blue,
                                  onPressed: () {
                                    GoRouter.of(context).goNamed(
                                        ContactFormScreen.routeName,
                                        extra: contact);

                                    // Navigator.of(context).push(
                                    //   MaterialPageRoute(
                                    //     builder: (context) =>
                                    //         ContactFormScreen(contact: contact),
                                    //   ),
                                    // );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  onPressed: () async {
                                    final bool didRequest =
                                        await showAlertDialog(
                                              context: context,
                                              title: "Delete",
                                              content:
                                                  "Are you sure you want to delete?",
                                              cancelActionText: "Cancel",
                                              defaultActionText: "Yes",
                                            ) ??
                                            false;
                                    if (didRequest == true) {
                                      ref
                                          .read(
                                              contactNotifierProvider.notifier)
                                          .deleteContact(
                                              contact.id, contact.userId);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: $err'),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      ref.invalidate(contactNotifierProvider);
                      GoRouter.of(context).goNamed(ContactListScreen.routeName);
                    },
                    child: const Text("Load Contacts"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const ContactFormScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

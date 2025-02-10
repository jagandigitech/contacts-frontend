import 'package:first_flutter_application_1/common/async_value_ui.dart';
import 'package:first_flutter_application_1/providers/auth_provider.dart';
import 'package:first_flutter_application_1/screens/account/login_screen.dart';
import 'package:first_flutter_application_1/screens/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MyProfileScreen extends ConsumerWidget {
  const MyProfileScreen({super.key});
  static String get routeName => 'myProfile';
  static String get routeLocation => '/$routeName';

  String getInitials(String accountText) {
    var parts = accountText.toString().trim().split(' ');
    var initials = '';
    for (var i = 0; i < parts.length; i++) {
      if (parts[i].isNotEmpty && parts[i] != '') {
        initials += parts[i][0];
      }
    }
    return initials.toUpperCase();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AsyncValue>(
      authProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InternContact - Profile',
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
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo, width: 3),
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 108, 245, 131),
                  Color.fromARGB(255, 240, 217, 141)
                ]),
                borderRadius: const BorderRadius.all(
                  Radius.circular(100),
                ),
              ),
              child: Center(
                child: Text(
                  getInitials(state.requireValue!.fullname.toString()),
                  style: const TextStyle(fontSize: 40, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.person),
                title: const Text(
                  'Full name',
                  style: TextStyle(color: Colors.black54),
                ),
                subtitle: Text(
                  state.requireValue!.fullname.toString(),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: ListTile(
                isThreeLine: true,
                leading: const Icon(Icons.phone),
                title: const Text(
                  'Mobile number (username)',
                  style: TextStyle(color: Colors.black54),
                ),
                subtitle: Text(
                  state.requireValue!.username.toString(),
                  style: const TextStyle(fontSize: 18, color: Colors.black),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                /* onPressed: () => context.go('/login'),
                      child: const Text(
                        'Logout',
                        style: TextStyle(fontSize: 22),
                      ),*/
                onPressed: state.isLoading
                    ? null
                    : () async {
                        ref.read(authProvider.notifier).signOut();

                        Future.delayed(const Duration(milliseconds: 300), () {
                          // ignore: use_build_context_synchronously
                          context.go(LoginScreen.routeLocation);
                        });
                      },
                child: Text(
                  'Logout',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Colors.indigo),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

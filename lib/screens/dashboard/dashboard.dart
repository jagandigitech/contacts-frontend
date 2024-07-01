import 'package:first_flutter_application_1/screens/account/profile_screen.dart';
import 'package:first_flutter_application_1/screens/contact/contact_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  static String get routeName => 'dashboard';
  static String get routeLocation => '/$routeName';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InternContact - Home',
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
            SizedBox(
              width: double.maxFinite,
              child: Card(
                color: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    context.go(ContactListScreen.routeLocation);
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        "Contacts",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: double.maxFinite,
              child: Card(
                color: Colors.white,
                elevation: 10,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    context.go(MyProfileScreen.routeLocation);
                  },
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.all(25.0),
                      child: Text(
                        "Profile",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

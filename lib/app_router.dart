import 'dart:async';

import 'package:first_flutter_application_1/models/contact.dart';
import 'package:first_flutter_application_1/providers/auth_provider.dart';
import 'package:first_flutter_application_1/screens/account/login_screen.dart';
import 'package:first_flutter_application_1/screens/account/profile_screen.dart';
import 'package:first_flutter_application_1/screens/account/register_screen.dart';
import 'package:first_flutter_application_1/screens/contact/contact_form_screen.dart';
import 'package:first_flutter_application_1/screens/contact/contact_list_screen.dart';
import 'package:first_flutter_application_1/screens/dashboard/dashboard.dart';
import 'package:first_flutter_application_1/screens/splash/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

extension GoRouteExtension on BuildContext {
  goPush<T>(String route) =>
      kIsWeb ? GoRouter.of(this).go(route) : GoRouter.of(this).push(route);
}

/// makes GoRouter redirect when stream recevies an event
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final _key = GlobalKey<NavigatorState>();

final routerProvider = Provider<GoRouter>((ref) {
  ref.watch(authProvider);
  final authNotifier = ref.read(authProvider.notifier);
  // final authNotifier = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _key,
    debugLogDiagnostics: true,
    initialLocation: SplashScreen.routeLocation,
    routes: [
      GoRoute(
        path: SplashScreen.routeLocation,
        name: SplashScreen.routeName,
        builder: (context, state) {
          return const SplashScreen();
        },
      ),
      GoRoute(
        path: LoginScreen.routeLocation,
        name: LoginScreen.routeName,
        builder: (context, state) {
          return const LoginScreen();
        },
      ),
      GoRoute(
        path: RegisterScreen.routeLocation,
        name: RegisterScreen.routeName,
        builder: (context, state) {
          return const RegisterScreen();
        },
      ),
      GoRoute(
        path: DashboardScreen.routeLocation,
        name: DashboardScreen.routeName,
        builder: (context, state) {
          return const DashboardScreen();
        },
      ),
      GoRoute(
        path: MyProfileScreen.routeLocation,
        name: MyProfileScreen.routeName,
        builder: (context, state) {
          return const MyProfileScreen();
        },
      ),
      GoRoute(
        path: ContactListScreen.routeLocation,
        name: ContactListScreen.routeName,
        builder: (context, state) {
          return const ContactListScreen();
        },
        routes: [
          GoRoute(
            path: ContactFormScreen.routeName,
            name: ContactFormScreen.routeName,
            builder: (context, state) {
              Contact contactObj =
                  state.extra as Contact; // -> casting is important
              return ContactFormScreen(
                contact: contactObj,
              );
            },
          ),
        ],
      ),
    ],
    redirect: (context, state) {
      // If our async state is loading, don't perform redirects, yet
      if (authNotifier.isLoading) return null;

      final isAuth = authNotifier.isAuthenticated;

      final isSplash = state.uri.toString() == SplashScreen.routeLocation;
      if (isSplash) {
        return isAuth
            ? DashboardScreen.routeLocation
            : LoginScreen.routeLocation;
      }

      final isLoggingIn = state.uri.toString() == LoginScreen.routeLocation;
      // if (isLoggingIn) return isAuth ? HomeScreen.routeLocation : null;

      if (isLoggingIn && isAuth) {
        if (state.uri.toString() == ContactListScreen.routeLocation) {
          return ContactListScreen.routeLocation;
        } else if (state.uri.toString() == ContactFormScreen.routeLocation) {
          return ContactFormScreen.routeLocation;
        } else if (state.uri.toString() == MyProfileScreen.routeLocation) {
          return MyProfileScreen.routeLocation;
        } else if (state.uri.toString() == DashboardScreen.routeLocation) {
          return DashboardScreen.routeLocation;
        }
      } else {
        return null;
      }

      return isAuth ? null : SplashScreen.routeLocation;
    },
  );
});

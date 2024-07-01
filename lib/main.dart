import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:first_flutter_application_1/app_router.dart';

final sharedPreferences =
    Provider<SharedPreferences>((_) => throw UnimplementedError());

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ),
  );

  //* Forcing only portrait orientation
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  final sharedPrefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferences.overrideWithValue(sharedPrefs),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Intern Contact App - 2024',
      theme: ThemeData(
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        buttonTheme: const ButtonThemeData(buttonColor: Colors.indigo),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      routerDelegate: router.routerDelegate,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
    );
  }
}

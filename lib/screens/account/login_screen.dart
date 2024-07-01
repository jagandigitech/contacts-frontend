import 'package:first_flutter_application_1/common/async_value_ui.dart';
import 'package:first_flutter_application_1/providers/auth_provider.dart';
import 'package:first_flutter_application_1/screens/account/register_screen.dart';
import 'package:first_flutter_application_1/view_models/login_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static String get routeName => 'login';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  late String? _username;
  late String? _passcode;
  late bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _username = '';
    _passcode = '';
    _passwordVisible = true;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue>(
      authProvider,
      (_, state) => state.showSnackBarOnError(context),
    );
    final state = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'InternContact - Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _username = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Passcode',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      // Update the state i.e. toogle the state of passwordVisible variable
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                keyboardType: TextInputType.number,
                obscureText: _passwordVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a passcode';
                  }
                  if (value.length > 6) {
                    return 'passcode length less than or equal to 6';
                  }
                  return null;
                },
                onSaved: (value) {
                  _passcode = value!;
                },
              ),
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
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            var loginRequest = LoginRequest(
                                username: _username, passcode: _passcode);
                            await ref
                                .read(authProvider.notifier)
                                .authenticate(loginRequest);

                            //Navigator.of(context).pop();
                          }
                        },
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('Login'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => context.go(RegisterScreen.routeLocation),
                child: const Text('New User? Register Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

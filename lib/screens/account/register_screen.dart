import 'package:first_flutter_application_1/common/async_value_ui.dart';
import 'package:first_flutter_application_1/providers/auth_provider.dart';
import 'package:first_flutter_application_1/screens/account/login_screen.dart';
import 'package:first_flutter_application_1/view_models/register_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  static String get routeName => 'register';
  static String get routeLocation => '/$routeName';

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _fullname;
  late String _username;
  late String _passcode;
  late bool _passwordVisible = true;

  @override
  void initState() {
    super.initState();
    _fullname = '';
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
          'InternContact - Register',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                initialValue: _fullname,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a full name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _fullname = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: _username,
                decoration: const InputDecoration(
                  labelText: 'Mobile Number (Username)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a mobile number';
                  }
                  if (value.length > 10) {
                    return 'Mobile number length less than or equal to 10';
                  }
                  return null;
                },
                onSaved: (value) {
                  _username = value!;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                initialValue: _passcode,
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
                  onPressed: state.isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            final registerRequest = RegisterRequest(
                                fullname: _fullname,
                                username: _username,
                                passcode: _passcode);

                            ref
                                .read(authProvider.notifier)
                                .register(registerRequest);

                            //Navigator.of(context).pop();
                          }
                        },
                  child: state.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('Register'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  context.go(LoginScreen.routeLocation);
                },
                child: const Text("Existing User Login Now!"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

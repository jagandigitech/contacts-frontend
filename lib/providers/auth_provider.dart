import 'dart:convert';

import 'package:first_flutter_application_1/main.dart';
import 'package:first_flutter_application_1/models/user.dart';
import 'package:first_flutter_application_1/view_models/login_request.dart';
import 'package:first_flutter_application_1/view_models/register_request.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

typedef AsyncUser = AsyncValue<UserData?>;

final authProvider = AsyncNotifierProvider<AuthNotifier, UserData?>(() {
  return AuthNotifier();
});

class AuthNotifier extends AsyncNotifier<UserData?> {
  AuthNotifier();

  static const userApiEndpointUrl =
      "https://contactdemo.jagandigitech.in/api/User";

  static const _authUserData = 'authUserData';

  @override
  FutureOr<UserData?> build() async {
    // ignore: deprecated_member_use
    ref.listenSelf((_, next) {
      final val = next.valueOrNull;
      if (val == null) {
        return;
      }
    });

    final prefs = ref.watch(sharedPreferences);

    if (!prefs.containsKey(_authUserData)) {
      return null;
    }

    var extractedUserData =
        json.decode(prefs.getString(_authUserData).toString())
            as Map<String, dynamic>;

    return UserData.fromJson(extractedUserData);
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final prefs1 = ref.watch(sharedPreferences);
    await prefs1.clear();
    state = const AsyncUser.data(null);
  }

  Future<void> register(RegisterRequest registerRequest) async {
    state = const AsyncLoading();
    try {
      final response = await http.post(
        Uri.parse("$userApiEndpointUrl/register"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(registerRequest.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userResponse = UserResponse.fromJson(jsonResponse);
        if (userResponse.status == true) {
          setSharedPrefAppUser(userResponse.data);
          state = AsyncData(userResponse.data);
        } else {
          throw Exception(userResponse.message);
        }
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  Future<void> authenticate(LoginRequest loginRequest) async {
    state = const AsyncLoading();
    try {
      final response = await http.post(
        Uri.parse("$userApiEndpointUrl/authenticate"),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(loginRequest.toJson()),
      );
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        final userResponse = UserResponse.fromJson(jsonResponse);
        if (userResponse.status == true) {
          setSharedPrefAppUser(userResponse.data);
          state = AsyncData(userResponse.data);
        } else {
          throw Exception(userResponse.message);
        }
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
    }
  }

  setSharedPrefAppUser(UserData? appUserData) {
    final prefs = ref.watch(sharedPreferences);
    final userData = json.encode(appUserData);
    prefs.setString(_authUserData, userData);
  }

  UserData? get authUserData => state.value!;
  bool get isAuthenticated => state.valueOrNull != null;
  bool get isLoading => state.isLoading;
  int? get userId => state.value!.id;
}

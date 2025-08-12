import 'package:flutter/material.dart';

import 'package:flutter_ali_nike/data/common/http.dart';

import 'package:flutter_ali_nike/data/source/Data_Source/auth_datasource.dart';
import 'package:flutter_ali_nike/data/source/Data/authinfo.dart';
import 'package:shared_preferences/shared_preferences.dart';

final repositoryAuth = IAuthRepository(AuthRemote(httpClient));

abstract class AuthRepository {
  Future<void> login(String username, String password);
  Future<void> signUp(String username, String password);
  Future<void> refreshToken();
  Future<void> signOut();
}

class IAuthRepository implements AuthRepository {
  final AuthDataSource dataSource;
  static final ValueNotifier<AuthData?> authChangeNotifier =
      ValueNotifier(null);

  IAuthRepository(this.dataSource);
  static bool isAuthI() {
    return authChangeNotifier.value != null &&
        authChangeNotifier.value!.accessToken.isNotEmpty;
  }

  @override
  Future<void> login(String username, String password) async {
    final AuthData authInfo = await dataSource.login(username, password);
    // StringA = 'hx';
    _persistsAuthToken(authInfo);
    debugPrint("access token is: ${authInfo.accessToken}");
  }

  @override
  Future<void> refreshToken() async {
    if (authChangeNotifier.value != null) {
      final AuthData authData =
          await dataSource.refreshToken(authChangeNotifier.value!.refreshToken);
      debugPrint('refresh token is: ${authData.refreshToken}');
      _persistsAuthToken(authData);
    }
  }

  @override
  Future<void> signUp(String username, String password) async {
    final AuthData authInfo = await dataSource.signUp(username, password);
    // StringA = 'hx';
    _persistsAuthToken(authInfo);
    debugPrint("access token is: ${authInfo.accessToken}");
  }

  Future<void> _persistsAuthToken(AuthData authData) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.setString("username", authData.email);
    sharedPreferences.setString("access_token", authData.accessToken);
    sharedPreferences.setString("refresh_token", authData.refreshToken);
    loadAuthInfo();
  }

  Future<void> loadAuthInfo() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    final String accessToken =
        sharedPreferences.getString("access_token") ?? '';

    final String email = sharedPreferences.getString("username") ?? "";

    final String refreshToken =
        sharedPreferences.getString("refresh_token") ?? '';
    if (accessToken.isNotEmpty && refreshToken.isNotEmpty) {
      authChangeNotifier.value = AuthData(accessToken, refreshToken, email);
    } else {}
  }

  @override
  Future<void> signOut() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    sharedPreferences.clear();
    authChangeNotifier.value = null;
  }
}

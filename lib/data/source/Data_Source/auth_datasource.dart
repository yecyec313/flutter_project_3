import 'package:dio/dio.dart';

import 'package:flutter_ali_nike/data/common/constants.dart';

import 'package:flutter_ali_nike/data/common/mixin.dart';
import 'package:flutter_ali_nike/data/source/Data/authinfo.dart';

abstract class AuthDataSource {
  Future<AuthData> login(String username, String password);
  Future<AuthData> signUp(String username, String password);
  Future<AuthData> refreshToken(String token);
}

class AuthRemote with HttpResponseValidator implements AuthDataSource {
  final Dio httpClient;

  AuthRemote(this.httpClient);
  @override
  Future<AuthData> login(String username, String password) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "password",
      "client_id": 2,
      "client_secret": Constants.clientSecret,
      "username": username,
      "password": password
    });

    // debugPrint(response.statusCode.toString());
    validateResponse(response);

    return AuthData(response.data["access_token"],
        response.data["refresh_token"], username);
  }

  @override
  Future<AuthData> refreshToken(String token) async {
    final response = await httpClient.post("auth/token", data: {
      "grant_type": "refresh_token",
      "refresh_token": token,
      "client_id": 2,
      "client_secret": Constants.clientSecret
    });

    validateResponse(response);

    return AuthData(
        response.data["access_token"], response.data["refresh_token"], "e");
  }

  @override
  Future<AuthData> signUp(String username, String password) async {
    final response = await httpClient
        .post("user/register", data: {"email": username, "password": password});
    validateResponse(response);

    return login(username, password);
  }
}

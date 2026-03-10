import 'dart:convert';

import 'package:client/core/constants/server_constants.dart';
import 'package:client/core/failure/failure.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_remote_repository.g.dart';

@riverpod
AuthRemoteRepository authRemoteRepository(Ref ref) {
  return AuthRemoteRepository();
}

class AuthRemoteRepository {
  Future<Either<AppFailure, UserModel>> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        headers: {"Content-Type": "application/json"},
        Uri.parse("${ServerConstants.baseUrl}/api/auth/signup"),
        body: jsonEncode({"name": name, "email": email, "password": password}),
      );
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200 || response.statusCode == 201) {
        return Right(UserModel.fromMap(responseBody));
      }

      return Left(AppFailure(responseBody["message"]));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        headers: {"Content-Type": "application/json"},
        Uri.parse("${ServerConstants.baseUrl}/api/auth/login"),
        body: jsonEncode({"email": email, "password": password}),
      );

      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        return Right(UserModel.fromMap(responseBody));
      }

      return Left(AppFailure(responseBody["message"]));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Left(AppFailure(e.toString()));
    }
  }

  Future<Either<AppFailure, UserModel>> getUser({required String token}) async {
    try {
      final response = await http.get(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        Uri.parse("${ServerConstants.baseUrl}/api/auth/user/me"),
      );
      print(response.body);
      final responseBody = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode == 200) {
        final user = UserModel.fromMap(responseBody).copyWith(token: token);
        return Right(user);
      }
      return Left(AppFailure(responseBody["message"]));
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
      return Left(AppFailure(e.toString()));
    }
  }
}

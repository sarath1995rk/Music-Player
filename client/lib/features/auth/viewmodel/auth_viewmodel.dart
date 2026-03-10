import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/features/auth/model/user_model.dart';
import 'package:client/features/auth/repository/auth_local_repository.dart';
import 'package:client/features/auth/repository/auth_remote_repository.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'auth_viewmodel.g.dart';

@riverpod
class AuthViewmodel extends _$AuthViewmodel {
  @override
  AsyncValue<UserModel>? build() {
    return null;
  }

  // Future<void> initSharedPreferences() async {
  //   await ref.read(authLocalRepositoryProvider).init();
  //   print("SharedPreferences initialized"); // ✅
  // }

  Future<void> signUpUser({
    required String name,
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final result = await ref
        .read(authRemoteRepositoryProvider)
        .signup(name: name, email: email, password: password);

    final val = switch (result) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => AsyncValue.data(r),
    };
    if (kDebugMode) {
      print(val);
    }
  }

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    state = AsyncValue.loading();
    final result = await ref
        .read(authRemoteRepositoryProvider)
        .login(email: email, password: password);

    final val = switch (result) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _loginSuccess(r),
    };
    if (kDebugMode) {
      print(val);
    }
  }

  AsyncValue<UserModel>? _loginSuccess(UserModel user) {
    AuthLocalRepository().saveToken(user.token);
    ref.read(currentUserProvider.notifier).addUser(user);
    return state = AsyncValue.data(user);
  }

  Future<UserModel?> getUser() async {
    state = AsyncValue.loading();
    final token = AuthLocalRepository().getToken();

    if (token != null) {
      final result = await ref
          .read(authRemoteRepositoryProvider)
          .getUser(token: token);
      final val = switch (result) {
        Left(value: final l) => state = AsyncValue.error(
          l.message,
          StackTrace.current,
        ),
        Right(value: final r) => _getUserData(r),
      };
      if (kDebugMode) {
        print(val);
      }
      return val.value;
    } else {
      state = AsyncValue.error("User not logged in", StackTrace.current);
    }
    return null;
  }

  AsyncValue<UserModel> _getUserData(UserModel user) {
    ref.read(currentUserProvider.notifier).addUser(user);
    AuthLocalRepository().saveToken(user.token);
    return state = AsyncValue.data(user);
  }
}

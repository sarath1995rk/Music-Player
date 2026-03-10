import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/features/auth/repository/auth_local_repository.dart';
import 'package:client/features/home/model/fav_song_model.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_view_model.g.dart';

@riverpod
Future<List<SongModel>> getAllSongs(Ref ref) async {
  final token = AuthLocalRepository().getToken();

  final res = await ref.watch(homeRepositoryProvider).getAllSongs(token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
Future<List<SongModel>> getFavSongs(Ref ref) async {
  final token = AuthLocalRepository().getToken();

  final res = await ref.watch(homeRepositoryProvider).getAllFavSongs(token);
  return switch (res) {
    Left(value: final l) => throw l.message,
    Right(value: final r) => r,
  };
}

@riverpod
class HomeViewModel extends _$HomeViewModel {
  @override
  AsyncValue? build() {
    return null;
  }

  List<SongModel> get allSongs =>
      ref.read(homeLocalRepositoryProvider).getAllSongs();

  Future<void> favSong({required String songId}) async {
    state = const AsyncValue.loading();
    final token = AuthLocalRepository().getToken();
    if (token == null) {
      state = AsyncValue.error("User not logged in", StackTrace.current);
      return;
    }

    final result = await ref
        .read(homeRepositoryProvider)
        .favouriteSong(token, songId);

    if (!ref.mounted) return;

    final val = switch (result) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => _favSongSuccess(r, songId),
    };
    if (kDebugMode) {
      print(val);
    }
  }

  AsyncValue _favSongSuccess(bool isFavourited, String songId) {
    final userNotifier = ref.read(currentUserProvider.notifier);
    if (isFavourited) {
      userNotifier.addUser(
        userNotifier.state!.copyWith(
          favorites: [
            ...ref.read(currentUserProvider)!.favorites,
            FavouriteSongModel(id: 0, userId: 0, songId: songId),
          ],
        ),
      );
    } else {
      userNotifier.addUser(
        userNotifier.state!.copyWith(
          favorites: [
            ...ref
                .read(currentUserProvider)!
                .favorites
                .where((element) => element.songId != songId),
          ],
        ),
      );
    }
    ref.invalidate(getFavSongsProvider);
    return state = AsyncValue.data(isFavourited);
  }
}

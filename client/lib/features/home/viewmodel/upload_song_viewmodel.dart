import 'dart:io';
import 'package:client/features/auth/repository/auth_local_repository.dart';
import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'upload_song_viewmodel.g.dart';

@riverpod
class UploadSongViewmodel extends _$UploadSongViewmodel {
  @override
  AsyncValue<SongModel>? build() => null;

  Future<void> uploadSong({
    required File song,
    required File thumbnail,
    required String artist,
    required String songName,
    required String hexCode,
  }) async {
    state = const AsyncValue.loading();
    final token = AuthLocalRepository().getToken();
    if (token == null) {
      state = AsyncValue.error("User not logged in", StackTrace.current);
      return;
    }

    final result = await ref
        .read(homeRepositoryProvider)
        .uploadSong(
          song: song,
          thumbnail: thumbnail,
          artist: artist,
          songName: songName,
          hexCode: hexCode,
          token: token,
        );

    if (!ref.mounted) return;
    print(result);
    final val = switch (result) {
      Left(value: final l) => state = AsyncValue.error(
        l.message,
        StackTrace.current,
      ),
      Right(value: final r) => state = AsyncValue.data(r),
    };
    print(val);
  }
}

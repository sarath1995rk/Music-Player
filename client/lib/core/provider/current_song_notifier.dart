import 'package:client/features/home/model/song_model.dart';
import 'package:client/features/home/repository/home_local_repository.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:just_audio/just_audio.dart';

part 'current_song_notifier.g.dart';

@riverpod
class CurrentSongNotifier extends _$CurrentSongNotifier {
  AudioPlayer? audioPlayer;

  @override
  SongModel? build() {
    return null;
  }

  void updateSong(SongModel song) async {
    await audioPlayer?.dispose();
    audioPlayer = AudioPlayer();
    final audioSource = AudioSource.uri(
      Uri.parse(song.songUrl),
      tag: MediaItem(
        id: song.id,
        title: song.songName,
        artist: song.artist,
        artUri: Uri.parse(song.thumbnailUrl),
      ),
    );
    await audioPlayer?.setAudioSource(audioSource);
    audioPlayer!.playerStateStream.listen((event) {
      if (event.processingState == ProcessingState.completed) {
        audioPlayer?.seek(Duration.zero);
        audioPlayer?.pause();
        state = state?.copyWith(isPlaying: false);
      }
    });
    ref.read(homeLocalRepositoryProvider).uploadLocalSong(song);
    audioPlayer?.play();
    state = song.copyWith(isPlaying: true);
  }

  void playPause() {
    if (state?.isPlaying == true) {
      audioPlayer?.pause();
    } else {
      audioPlayer?.play();
    }
    state = state?.copyWith(isPlaying: !(state?.isPlaying ?? false));
  }

  void seek(double val) {
    audioPlayer?.seek(
      Duration(
        milliseconds: (val * audioPlayer!.duration!.inMilliseconds).toInt(),
      ),
    );
  }
}

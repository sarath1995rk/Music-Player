import 'package:client/features/home/model/song_model.dart';
import 'package:hive/hive.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'home_local_repository.g.dart';

@Riverpod(keepAlive: true)
HomeLocalRepository homeLocalRepository(Ref ref) => HomeLocalRepository();

class HomeLocalRepository {
  final Box box = Hive.box('songBox');

  void uploadLocalSong(SongModel song) {
    box.put(song.id, song.toJson());
  }

  List<SongModel> getAllSongs() {
    List<SongModel> songs = [];
    for (final key in box.keys) {
      songs.add(SongModel.fromJson(box.get(key)));
    }
    return songs;
  }
}

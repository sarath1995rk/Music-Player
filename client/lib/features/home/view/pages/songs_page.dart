import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SongsPage extends ConsumerWidget {
  const SongsPage({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final recentlyPlayedSongs = ref
        .watch(homeViewModelProvider.notifier)
        .allSongs;
    final currentSong = ref.watch(currentSongProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      decoration: currentSong == null
          ? null
          : BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(int.parse('0xFF${currentSong.hexCode}')),
                  Pallete.transparentColor,
                ],
                stops: [0.0, 0.3],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              bottom: 36.0,
              right: 16.0,
            ),
            child: GridView.builder(
              shrinkWrap: true,
              itemCount: recentlyPlayedSongs.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                crossAxisSpacing: 8,
                childAspectRatio: 3,
                mainAxisSpacing: 8,
              ),
              itemBuilder: (contxt, index) {
                final song = recentlyPlayedSongs[index];
                return GestureDetector(
                  onTap: () {
                    ref.read(currentSongProvider.notifier).updateSong(song);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: Pallete.borderColor,
                      borderRadius: BorderRadius.circular(6.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 56,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: NetworkImage(song.thumbnailUrl),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(4),
                              bottomLeft: Radius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            song.songName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Latest today',
              style: TextStyle(fontSize: 23, fontWeight: FontWeight.w700),
            ),
          ),
          ref
              .watch(getAllSongsProvider)
              .when(
                data: (songs) {
                  return SizedBox(
                    height: 260,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        final song = songs[index];

                        return GestureDetector(
                          onTap: () {
                            ref
                                .read(currentSongProvider.notifier)
                                .updateSong(song);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  height: 180,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: NetworkImage(song.thumbnailUrl),
                                      fit: BoxFit.cover,
                                    ),
                                    borderRadius: BorderRadius.circular(7),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.songName,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                SizedBox(
                                  width: 180,
                                  child: Text(
                                    song.artist,
                                    style: const TextStyle(
                                      color: Pallete.subtitleText,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
                error: (error, st) {
                  return Center(child: Text(error.toString()));
                },
                loading: () => const CircularProgressIndicator.adaptive(),
              ),
        ],
      ),
    );
  }
}

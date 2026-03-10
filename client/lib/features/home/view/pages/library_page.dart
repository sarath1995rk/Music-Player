import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/pages/upload_song_page.dart';
import 'package:client/features/home/viewmodel/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LibraryPage extends ConsumerWidget {
  const LibraryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getFavSongsProvider)
        .when(
          data: (data) {
            return ListView.builder(
              itemBuilder: (context, index) {
                if (index == data.length) {
                  return ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const UploadSongPage(),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 35,
                      backgroundColor: Pallete.backgroundColor,
                      child: const Icon(CupertinoIcons.plus),
                    ),
                    title: const Text(
                      "Upload New Song",
                      style: TextStyle(
                        color: Pallete.whiteColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  );
                }

                final song = data[index];
                return ListTile(
                  onTap: () {
                    ref.read(currentSongProvider.notifier).updateSong(song);
                  },
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(song.thumbnailUrl),
                    radius: 35,
                    backgroundColor: Pallete.backgroundColor,
                  ),
                  title: Text(
                    song.songName,
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  subtitle: Text(
                    song.artist,
                    style: TextStyle(
                      color: Pallete.whiteColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
              itemCount: data.length + 1,
            );
          },
          error: (error, stackTrace) {
            return Center(child: Text(error.toString()));
          },
          loading: () => Center(child: CircularProgressIndicator.adaptive()),
        );
  }
}

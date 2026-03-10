import 'package:client/core/provider/current_song_notifier.dart';
import 'package:client/core/provider/current_user_notifier.dart';
import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/home/view/widgets/music_player.dart';
import 'package:client/features/home/viewmodel/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicSlab extends ConsumerWidget {
  const MusicSlab({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final currentSong = ref.watch(currentSongProvider);
    final songNotifier = ref.read(currentSongProvider.notifier);
    final userFavorites = ref
        .watch(currentUserProvider.select((data) => data!.favorites))
        .map((fav) => fav.songId)
        .toList();
    if (currentSong == null) {
      return const SizedBox.shrink();
    }
   
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              return const MusicPlayer();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  final tween = Tween(
                    begin: const Offset(0, 1),
                    end: Offset.zero,
                  ).chain(CurveTween(curve: Curves.easeIn));

                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        );
      },
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            height: 66,
            width: MediaQuery.of(context).size.width - 16,
            decoration: BoxDecoration(
              color: Color(int.parse('0xFF${currentSong.hexCode}')),
              borderRadius: BorderRadius.circular(4),
            ),
            padding: const EdgeInsets.all(9.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Hero(
                      tag: "music-image",
                      child: Container(
                        width: 48,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(currentSong.thumbnailUrl),
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          currentSong.songName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          currentSong.artist,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Pallete.subtitleText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        userFavorites.contains(currentSong.id)
                            ? CupertinoIcons.heart_fill
                            : CupertinoIcons.heart,
                        color: Pallete.whiteColor,
                      ),
                      onPressed: () {
                        ref
                            .read(homeViewModelProvider.notifier)
                            .favSong(songId: currentSong.id);
                      },
                    ),
                    IconButton(
                      onPressed: () {
                        songNotifier.playPause();
                      },
                      icon: Icon(
                        currentSong.isPlaying == true
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: Pallete.whiteColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          StreamBuilder(
            stream: songNotifier.audioPlayer?.positionStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox.shrink();
              }
              final position = snapshot.data;
              final duration = songNotifier.audioPlayer?.duration;
              if (position == null || duration == null) {
                return const SizedBox.shrink();
              }
              final sliderValue =
                  position.inMilliseconds / duration.inMilliseconds;

              return Positioned(
                bottom: 0,
                left: 8.0,
                child: Container(
                  height: 2,
                  width: sliderValue * (MediaQuery.of(context).size.width - 32),
                  decoration: BoxDecoration(
                    color: Pallete.whiteColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 0,
            left: 8.0,
            child: Container(
              height: 2,
              width: MediaQuery.of(context).size.width - 32,
              decoration: BoxDecoration(
                color: Pallete.inactiveSeekColor,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
